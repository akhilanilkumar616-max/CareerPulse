import logging
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from database import get_db
from models.db_models import UserProfileRecord

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/profile", tags=["User Profile"])


class UserProfileSchema(BaseModel):
    user_id: str = Field(..., description="Unique user/candidate UID")
    full_name: str = Field(..., description="Candidate full name")
    email: Optional[str] = Field(None, description="Candidate email address")
    education_level: Optional[str] = Field(None, description="Highest degree / qualification")
    institution: Optional[str] = Field(None, description="University / College / School")
    specialization: Optional[str] = Field(None, description="Major / Field of study")
    graduation_year: Optional[str] = Field(None, description="Graduation year / Cohort")
    skills: List[str] = Field(default_factory=list, description="Mastered technical skills")
    career_interests: List[str] = Field(default_factory=list, description="Target job roles")
    summary: Optional[str] = Field(None, description="Personal career summary / elevator pitch")


@router.get("/{user_id}", status_code=status.HTTP_200_OK, summary="Get candidate profile")
def get_user_profile(user_id: str, db: Session = Depends(get_db)):
    """Retrieve candidate employability profile from PostgreSQL."""
    profile = db.query(UserProfileRecord).filter(UserProfileRecord.user_id == user_id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Profile for user '{user_id}' not found.",
        )
    return profile.to_dict()


@router.post("", status_code=status.HTTP_200_OK, summary="Create or update candidate profile")
def upsert_user_profile(payload: UserProfileSchema, db: Session = Depends(get_db)):
    """Create or update candidate profile in PostgreSQL."""
    profile = db.query(UserProfileRecord).filter(UserProfileRecord.user_id == payload.user_id).first()
    
    if profile:
        profile.full_name = payload.full_name
        profile.email = payload.email
        profile.education_level = payload.education_level
        profile.institution = payload.institution
        profile.specialization = payload.specialization
        profile.graduation_year = payload.graduation_year
        profile.skills = payload.skills
        profile.career_interests = payload.career_interests
        profile.summary = payload.summary
    else:
        profile = UserProfileRecord(
            user_id=payload.user_id,
            full_name=payload.full_name,
            email=payload.email,
            education_level=payload.education_level,
            institution=payload.institution,
            specialization=payload.specialization,
            graduation_year=payload.graduation_year,
            skills=payload.skills,
            career_interests=payload.career_interests,
            summary=payload.summary,
        )
        db.add(profile)

    try:
        db.commit()
        db.refresh(profile)
        logger.info(f"Upserted profile for user_id={payload.user_id}")
        return profile.to_dict()
    except Exception as e:
        db.rollback()
        logger.error(f"Failed to upsert profile: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to save profile into PostgreSQL database.",
        )
