from enum import Enum
from typing import List, Optional
from pydantic import BaseModel, Field


class SkillStatus(str, Enum):
    MATCHED = "matched"
    PARTIAL = "partial"
    POTENTIAL_GAP = "potential_gap"


class SkillMatchItem(BaseModel):
    name: str = Field(..., description="Canonical name of the technical skill")
    status: SkillStatus = Field(..., description="Classification status of the skill requirement")
    resume_evidence: Optional[str] = Field(None, description="Actual excerpt from the resume supporting the skill")
    reason: Optional[str] = Field(None, description="Explanation for partial match or potential gap classification")


class SkillRecommendationItem(BaseModel):
    skill: str = Field(..., description="Target skill needing improvement or verification")
    recommendation: str = Field(..., description="Concrete, actionable advice for mastering or demonstrating this skill")


class AnalyzeResumeResponse(BaseModel):
    job_title: str = Field(..., description="Target job title analyzed")
    match_score: int = Field(..., ge=0, le=100, description="Estimated Job Skill Match score (0-100)")
    matched_skills: List[SkillMatchItem] = Field(default_factory=list, description="Skills confirmed in both resume and job description")
    partial_skills: List[SkillMatchItem] = Field(default_factory=list, description="Skills with related evidence needing verification")
    potential_missing_skills: List[SkillMatchItem] = Field(default_factory=list, description="Job requirements not identified in the resume")
    recommendations: List[SkillRecommendationItem] = Field(default_factory=list, description="Targeted learning & resume refinement tips")
    summary: str = Field(..., description="Executive narrative summary of candidate alignment")


class HealthResponse(BaseModel):
    status: str
    service: str
