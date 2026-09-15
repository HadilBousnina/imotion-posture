from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.dashboard import DashboardStatsRead
from app.core.dependencies import get_current_user
import app.services.dashboard_service as dashboard_service


router = APIRouter(
    prefix="/dashboard",
    tags=["Dashboard"],
)


@router.get(
    "/stats",
    response_model=DashboardStatsRead,
)
def get_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return dashboard_service.get_dashboard_stats(
        db,
        current_user.id_coach,
    )