from fastapi import APIRouter
from models.schemas import HealthResponse

router = APIRouter(tags=["Health"])


@router.get("/health", response_model=HealthResponse)
def health_check():
    """Health check endpoint to verify backend service readiness."""
    return HealthResponse(
        status="ok",
        service="career-pulse-analysis",
    )
