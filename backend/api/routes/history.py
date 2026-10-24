import logging
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from database import get_db
from models.db_models import AnalysisRecord

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/history", tags=["Analysis History"])


@router.get("", status_code=status.HTTP_200_OK, summary="List assessment history")
def list_history(
    user_id: Optional[str] = Query(None, description="Filter assessments by candidate user ID"),
    limit: int = Query(20, ge=1, le=100, description="Maximum records to return"),
    offset: int = Query(0, ge=0, description="Offset for pagination"),
    db: Session = Depends(get_db),
):
    """Retrieve historical resume analysis assessments stored in PostgreSQL."""
    query = db.query(AnalysisRecord)
    if user_id:
        query = query.filter(AnalysisRecord.user_id == user_id)
    
    records = query.order_by(AnalysisRecord.created_at.desc()).offset(offset).limit(limit).all()
    return [r.to_dict() for r in records]


@router.get("/{record_id}", status_code=status.HTTP_200_OK, summary="Get assessment by ID")
def get_history_item(
    record_id: int,
    db: Session = Depends(get_db),
):
    """Fetch full details of a specific resume assessment record."""
    record = db.query(AnalysisRecord).filter(AnalysisRecord.id == record_id).first()
    if not record:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Assessment record #{record_id} not found.",
        )
    return record.to_dict()


@router.delete("/{record_id}", status_code=status.HTTP_200_OK, summary="Delete assessment record")
def delete_history_item(
    record_id: int,
    db: Session = Depends(get_db),
):
    """Delete an assessment record from PostgreSQL."""
    record = db.query(AnalysisRecord).filter(AnalysisRecord.id == record_id).first()
    if not record:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Assessment record #{record_id} not found.",
        )
    db.delete(record)
    db.commit()
    return {"status": "success", "message": f"Assessment #{record_id} deleted successfully."}
