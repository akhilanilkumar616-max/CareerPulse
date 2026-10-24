"""
Validation test suite verifying all 24 multi-domain test resumes:
1. Validates genuine PDF binary structure and text extraction via PDFExtractor.
2. Verifies domain skill extraction via SkillExtractor.
3. Verifies end-to-end skill matching, scoring, and recommendation generation via SkillMatcher.
"""

import json
import os
import sys
import pytest

# Ensure backend root is in sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from services.pdf_extractor import PDFExtractor
from services.skill_extractor import SkillExtractor
from services.skill_matcher import SkillMatcher
from models.schemas import SkillStatus


CATALOG_PATH = os.path.join(os.path.dirname(__file__), "sample_resumes", "catalog.json")


def load_catalog():
    if not os.path.exists(CATALOG_PATH):
        # Generate them if not already created
        from tests.generate_test_resume import generate_all_resumes
        generate_all_resumes(os.path.join(os.path.dirname(__file__), "sample_resumes"))

    with open(CATALOG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


CATALOG = load_catalog()


def test_catalog_has_at_least_10_fields():
    """Verify at least 10 distinct job fields are included."""
    fields = set(item["field_id"] for item in CATALOG)
    assert len(fields) >= 10, f"Expected at least 10 fields, found {len(fields)}"


def test_each_field_has_multiple_positions():
    """Verify each job field has multiple distinct job positions."""
    field_to_positions = {}
    for item in CATALOG:
        field_to_positions.setdefault(item["field_id"], []).append(item["position_id"])

    for field_id, positions in field_to_positions.items():
        assert len(positions) >= 2, f"Field {field_id} has fewer than 2 positions: {positions}"
        # Ensure position IDs are unique within the field
        assert len(set(positions)) == len(positions), f"Duplicate positions in field {field_id}"


@pytest.mark.parametrize("item", CATALOG, ids=[f"{item['field_id']}-{item['position_id']}" for item in CATALOG])
def test_resume_extraction_and_matching(item):
    """
    Validates that each resume:
    1. Extracts clean text above minimum length.
    2. Has recognized domain skills.
    3. Runs through SkillMatcher producing realistic match score (> 50%) and recommendations.
    """
    filepath = os.path.join(os.path.dirname(__file__), "sample_resumes", item["filename"])
    assert os.path.exists(filepath), f"Missing resume file: {filepath}"

    with open(filepath, "rb") as f:
        pdf_bytes = f.read()

    # 1. Text extraction
    extracted_text = PDFExtractor.validate_and_extract(pdf_bytes, item["filename"])
    assert len(extracted_text) >= 200, f"Extracted text too short for {item['filename']}"
    assert item["candidate_name"].split()[0].lower() in extracted_text.lower(), "Candidate name missing from extracted text"

    # 2. Skill extraction
    skills = SkillExtractor.extract_skills_with_evidence(extracted_text)
    assert len(skills) >= 4, f"Too few skills extracted ({len(skills)}) for {item['filename']}"

    # 3. Matching against target job description
    target_job = item["target_job"]
    analysis = SkillMatcher.analyze(
        resume_text=extracted_text,
        job_description=target_job["description"],
        job_title=target_job["title"],
    )

    assert analysis.match_score >= 50, f"Match score {analysis.match_score} below 50% for {item['filename']}"
    assert len(analysis.matched_skills) >= 3, f"Expected at least 3 matched skills for {item['filename']}"
    assert analysis.summary is not None
