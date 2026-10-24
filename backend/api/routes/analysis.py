import logging
from typing import Optional
from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from sqlalchemy.orm import Session

from database import get_db
from models.db_models import AnalysisRecord
from models.schemas import AnalyzeResumeResponse
from services.pdf_extractor import PDFExtractionError, PDFExtractor
from services.skill_matcher import SkillMatcher

logger = logging.getLogger(__name__)

router = APIRouter(tags=["Resume Analysis"])


@router.post(
    "/analyze-resume",
    response_model=AnalyzeResumeResponse,
    status_code=status.HTTP_200_OK,
    summary="Analyze candidate PDF resume against job description",
    description=(
        "Accepts a candidate PDF resume and target job description, extracts "
        "skills using rule-based NLP, performs semantic matching with Sentence Transformers, "
        "computes a transparent skill gap report, and persists the assessment to PostgreSQL."
    ),
)
async def analyze_resume(
    resume: UploadFile = File(..., description="Candidate resume in PDF format"),
    job_title: str = Form(..., description="Target job title or role name"),
    company_name: Optional[str] = Form(None, description="Optional hiring company name"),
    job_description: str = Form(..., description="Full text of the target job description"),
    user_id: Optional[str] = Form(None, description="Optional candidate user ID to associate history"),
    db: Session = Depends(get_db),
):
    # 1. Validate inputs
    if not job_title or not job_title.strip():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Target job role is required.",
        )

    if not job_description or len(job_description.strip()) < 30:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Please provide a more detailed job description (minimum 30 characters).",
        )

    if not resume.filename or not resume.filename.lower().endswith(".pdf"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Please upload a valid PDF resume file (.pdf).",
        )

    # 2. Read resume bytes
    try:
        file_bytes = await resume.read()
    except Exception as e:
        logger.error(f"Failed to read uploaded file: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Failed to read the uploaded resume file.",
        )

    # 3. Extract and validate text via PyMuPDF
    try:
        resume_text = PDFExtractor.validate_and_extract(file_bytes, resume.filename)
    except PDFExtractionError as pe:
        logger.warning(f"PDF validation failed: {pe}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(pe),
        )
    except Exception as e:
        logger.error(f"Unexpected PDF extraction error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred while processing the PDF file.",
        )

    # 4. Perform skill matching and gap calculation
    try:
        analysis_report = SkillMatcher.analyze(
            resume_text=resume_text,
            job_description=job_description.strip(),
            job_title=job_title.strip(),
            company_name=company_name.strip() if company_name else None,
        )
    except ValueError as ve:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(ve),
        )
    except Exception as e:
        logger.error(f"Skill matching execution failed: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An error occurred during semantic skill matching. Please try again.",
        )

    # 5. Persist assessment record to PostgreSQL
    try:
        record = AnalysisRecord(
            user_id=user_id.strip() if user_id else None,
            job_title=job_title.strip(),
            company_name=company_name.strip() if company_name else None,
            match_score=analysis_report.match_score,
            matched_skills=[item.model_dump() for item in analysis_report.matched_skills],
            partial_skills=[item.model_dump() for item in analysis_report.partial_skills],
            potential_missing_skills=[item.model_dump() for item in analysis_report.potential_missing_skills],
            recommendations=[item.model_dump() for item in analysis_report.recommendations],
            summary=analysis_report.summary,
        )
        db.add(record)
        db.commit()
        db.refresh(record)
        logger.info(f"Persisted analysis report ID={record.id} for user_id={user_id} into PostgreSQL.")
    except Exception as dbe:
        db.rollback()
        logger.warning(f"Failed to persist analysis to database (results returned without caching): {dbe}")

    return analysis_report
