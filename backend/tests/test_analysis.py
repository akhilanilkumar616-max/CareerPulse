import os
import sys
import pytest
import pymupdf as fitz
from fastapi.testclient import TestClient

# Ensure backend root is on sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from main import app
from services.pdf_extractor import PDFExtractor, PDFExtractionError
from services.skill_extractor import SkillExtractor
from services.skill_matcher import SkillMatcher
from models.schemas import SkillStatus

client = TestClient(app)


def create_sample_pdf_bytes(text_content: str) -> bytes:
    """Helper to generate in-memory genuine PDF bytes for testing."""
    doc = fitz.open()
    page = doc.new_page()
    page.insert_text((50, 72), text_content)
    pdf_bytes = doc.tobytes()
    doc.close()
    return pdf_bytes


# 1. PDF Validation Tests
def test_pdf_validation_empty_bytes():
    with pytest.raises(PDFExtractionError) as exc_info:
        PDFExtractor.validate_and_extract(b"", "empty.pdf")
    assert "empty" in str(exc_info.value).lower()


def test_pdf_validation_invalid_header():
    with pytest.raises(PDFExtractionError) as exc_info:
        PDFExtractor.validate_and_extract(b"NOT_A_PDF_FILE_HEADER", "resume.pdf")
    assert "not a valid pdf" in str(exc_info.value).lower()


def test_pdf_validation_scanned_without_selectable_text():
    # PDF with virtually no text
    empty_pdf = create_sample_pdf_bytes("")
    with pytest.raises(PDFExtractionError) as exc_info:
        PDFExtractor.validate_and_extract(empty_pdf, "scanned.pdf")
    assert "selectable text" in str(exc_info.value).lower()


# 2. PDF Text Extraction & Normalization
def test_pdf_text_extraction_success():
    sample_text = (
        "John Doe - Software Engineer\n"
        "Proficient in Python, JavaScript, and Docker.\n"
        "Built responsive web apps with HTML, CSS, and React.\n"
    )
    pdf_bytes = create_sample_pdf_bytes(sample_text)
    extracted = PDFExtractor.validate_and_extract(pdf_bytes, "valid_resume.pdf")

    assert "Python" in extracted
    assert "JavaScript" in extracted
    assert "Docker" in extracted


def test_text_normalization_whitespace():
    raw = "Python   Developer \n\n\n\nwith   experience in  Django\r\n"
    normalized = PDFExtractor.normalize_text(raw)
    assert "\n\n\n" not in normalized
    assert "   " not in normalized
    assert "Python Developer" in normalized


# 3. Skill Normalization Tests
def test_skill_normalization_mapping():
    assert SkillExtractor.NORMALIZATION_MAP["js"] == "JavaScript"
    assert SkillExtractor.NORMALIZATION_MAP["reactjs"] == "React"
    assert SkillExtractor.NORMALIZATION_MAP["nodejs"] == "Node.js"
    assert SkillExtractor.NORMALIZATION_MAP["postgres"] == "PostgreSQL"
    assert SkillExtractor.NORMALIZATION_MAP["k8s"] == "Kubernetes"
    assert SkillExtractor.NORMALIZATION_MAP["ml"] == "Machine Learning"


def test_skill_safe_extraction_no_false_positives():
    # "Cat" should NOT match "C", "Java" should NOT match "JavaScript"
    text = "The candidate owns a Cat and develops applications using Java."
    extracted = SkillExtractor.extract_skills_with_evidence(text)
    assert "Java" in extracted
    assert "JavaScript" not in extracted
    assert "C" not in extracted


# 4. Skill Matching and Classification Tests
def test_skill_matching_classifications():
    resume_text = (
        "Experienced Developer proficient in Python, SQL, and Docker. "
        "Built REST APIs and microservices using FastAPI and MySQL."
    )
    job_description = (
        "We require a Backend Developer with Python, SQL, Docker, React, and Kubernetes."
    )

    result = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description=job_description,
        job_title="Backend Developer",
    )

    matched_names = [s.name for s in result.matched_skills]
    missing_names = [s.name for s in result.potential_missing_skills]

    # Python, SQL, Docker should be matched
    assert "Python" in matched_names
    assert "SQL" in matched_names
    assert "Docker" in matched_names

    # Kubernetes and React should be potential gaps
    assert "Kubernetes" in missing_names or "React" in missing_names


# 5. Transparent Match Score Calculation
def test_match_score_calculation():
    resume_text = "Proficient in Python and SQL."
    # 2 skills required, 2 present -> 100%
    result = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description="Requirements: Python, SQL.",
        job_title="Data Analyst",
    )
    assert result.match_score == 100

    # 4 skills required, 2 present -> ~50%
    result_half = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description="Requirements: Python, SQL, Docker, Kubernetes.",
        job_title="Data Analyst",
    )
    assert 45 <= result_half.match_score <= 55


# 6. Invalid or Empty Job Description
def test_empty_job_description_handling():
    with pytest.raises(ValueError) as exc_info:
        SkillMatcher.analyze(
            resume_text="Python developer with SQL experience.",
            job_description="Please apply by email. Good luck.",
            job_title="Software Engineer",
        )
    assert "technical requirements" in str(exc_info.value).lower()


# 7. FastAPI API Endpoints Tests
def test_health_check_endpoint():
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "ok"
    assert data["service"] == "career-pulse-analysis"


def test_analyze_resume_endpoint_empty_job_title():
    pdf_bytes = create_sample_pdf_bytes("John Doe - Python Developer with SQL experience.")
    response = client.post(
        "/api/v1/analyze-resume",
        data={
            "job_title": "",
            "job_description": "We require Python and SQL for this engineering position.",
        },
        files={"resume": ("resume.pdf", pdf_bytes, "application/pdf")},
    )
    assert response.status_code in [400, 422]
    detail = str(response.json())
    assert "job" in detail.lower() or "required" in detail.lower() or "field" in detail.lower()


# 8. Cross-Disciplinary Domain Tests (Civil Engineering, Animation, Nursing)
def test_civil_engineering_extraction_and_gap():
    resume_text = (
        "Civil Engineer with 4 years of site experience. Proficient in AutoCAD, site safety management, "
        "and land surveying. Coordinated concrete casting and construction supervision."
    )
    job_description = (
        "Looking for a Senior Structural / Civil Engineer. Required skills include AutoCAD, "
        "STAAD.Pro, Structural Analysis, and Geotechnical Engineering. Experience with Revit is a plus."
    )
    # Verify direct extraction
    extracted_resume = SkillExtractor.extract_skills_with_evidence(resume_text)
    assert "AutoCAD" in extracted_resume
    assert "Site Safety" in extracted_resume

    result = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description=job_description,
        job_title="Structural Civil Engineer",
    )
    matched_names = [s.name for s in result.matched_skills]
    missing_names = [s.name for s in result.potential_missing_skills]

    assert "AutoCAD" in matched_names
    assert any(m in missing_names for m in ["STAAD.Pro", "Structural Analysis", "Geotechnical Engineering"])
    # Verify actionable recommendations generated for missing civil skills
    rec_text = " ".join(r.recommendation for r in result.recommendations)
    assert any(term in rec_text for term in ["STAAD.Pro", "Structural Analysis", "Civil", "analysis"])


def test_animation_extraction_and_gap():
    resume_text = (
        "3D Artist and Animator with hands-on expertise in Blender, 2D storyboarding, "
        "keyframing, and character animation for independent short films."
    )
    job_description = (
        "Lead 3D Animator needed. Must be fluent in Maya, Blender, character rigging, "
        "motion graphics, and Adobe After Effects for high-end cinematic production."
    )
    extracted_resume = SkillExtractor.extract_skills_with_evidence(resume_text)
    assert "Blender" in extracted_resume
    assert "Storyboarding" in extracted_resume

    result = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description=job_description,
        job_title="3D Animator",
    )
    matched_names = [s.name for s in result.matched_skills]
    missing_names = [s.name for s in result.potential_missing_skills]

    assert "Blender" in matched_names
    assert any(m in missing_names for m in ["Maya", "Rigging", "Motion Graphics", "After Effects"])
    rec_text = " ".join(r.recommendation for r in result.recommendations)
    assert any(term.lower() in rec_text.lower() for term in ["maya", "rigging", "motion graphics", "animation", "portfolio"])


def test_nursing_extraction_and_gap():
    resume_text = (
        "Registered Nurse with experience in Emergency Care. Proficient in Patient Triage, "
        "vital signs monitoring, patient assessment, and BLS certification."
    )
    job_description = (
        "Seeking an ICU Registered Nurse. Requirements: Patient Triage, ACLS Certification, "
        "EHR/EMR Charting, HIPAA Compliance, and Pharmacology."
    )
    extracted_resume = SkillExtractor.extract_skills_with_evidence(resume_text)
    assert "Patient Triage" in extracted_resume
    assert "BLS Certification" in extracted_resume

    result = SkillMatcher.analyze(
        resume_text=resume_text,
        job_description=job_description,
        job_title="ICU Registered Nurse",
    )
    matched_names = [s.name for s in result.matched_skills]
    missing_names = [s.name for s in result.potential_missing_skills]

    assert "Patient Triage" in matched_names
    assert any(m in missing_names for m in ["ACLS", "EHR/EMR", "HIPAA Compliance", "Pharmacology"])
    rec_text = " ".join(r.recommendation for r in result.recommendations)
    assert any(term.lower() in rec_text.lower() for term in ["acls", "hipaa", "ehr", "pharmacology", "nursing", "clinical"])


