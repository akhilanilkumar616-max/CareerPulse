import datetime
from sqlalchemy import Column, Integer, String, Text, DateTime, JSON
from database import Base


class AnalysisRecord(Base):
    """Stores candidate resume evaluation history in PostgreSQL."""
    __tablename__ = "analysis_history"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(128), index=True, nullable=True)
    job_title = Column(String(255), nullable=False)
    company_name = Column(String(255), nullable=True)
    match_score = Column(Integer, nullable=False)
    
    # Structured JSON fields storing canonical skill items & actionable recommendations
    matched_skills = Column(JSON, nullable=False, default=list)
    partial_skills = Column(JSON, nullable=False, default=list)
    potential_missing_skills = Column(JSON, nullable=False, default=list)
    recommendations = Column(JSON, nullable=False, default=list)
    
    summary = Column(Text, nullable=False)
    created_at = Column(DateTime(timezone=True), default=datetime.datetime.utcnow, index=True)

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "job_title": self.job_title,
            "company_name": self.company_name,
            "match_score": self.match_score,
            "matched_skills": self.matched_skills,
            "partial_skills": self.partial_skills,
            "potential_missing_skills": self.potential_missing_skills,
            "recommendations": self.recommendations,
            "summary": self.summary,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class UserProfileRecord(Base):
    """Stores candidate employability profile and technical skills in PostgreSQL."""
    __tablename__ = "user_profiles"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(128), unique=True, index=True, nullable=False)
    full_name = Column(String(255), nullable=False)
    email = Column(String(255), nullable=True)
    education_level = Column(String(100), nullable=True)
    institution = Column(String(255), nullable=True)
    specialization = Column(String(255), nullable=True)
    graduation_year = Column(String(50), nullable=True)
    
    # Canonical technical skill tags and target career role tags
    skills = Column(JSON, nullable=False, default=list)
    career_interests = Column(JSON, nullable=False, default=list)
    summary = Column(Text, nullable=True)
    
    created_at = Column(DateTime(timezone=True), default=datetime.datetime.utcnow)
    updated_at = Column(
        DateTime(timezone=True),
        default=datetime.datetime.utcnow,
        onupdate=datetime.datetime.utcnow,
    )

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "full_name": self.full_name,
            "email": self.email,
            "education_level": self.education_level,
            "institution": self.institution,
            "specialization": self.specialization,
            "graduation_year": self.graduation_year,
            "skills": self.skills,
            "career_interests": self.career_interests,
            "summary": self.summary,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
