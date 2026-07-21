from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.coach import (
    CoachRead,
    CoachUpdate,
)
from app.core.dependencies import get_current_user
from app.services import coach_service

router = APIRouter(
    prefix="/coaches",
    tags=["Coaches"],
)


# ==========================
# GET ALL
# ==========================

@router.get(
    "/",
    response_model=list[CoachRead],
)
def get_all_coaches(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    """
    Retourne tous les coachs.
    """
    return coach_service.get_all_coachs(db)


# ==========================
# GET ONE
# ==========================

@router.get(
    "/{id_coach}",
    response_model=CoachRead,
)
def get_coach(
    id_coach: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    """
    Retourne un coach par son identifiant.
    """

    coach = coach_service.get_coach(
        db,
        id_coach,
    )

    if coach is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach introuvable.",
        )

    return coach


# ==========================
# UPDATE
# ==========================

@router.put(
    "/{id_coach}",
    response_model=CoachRead,
)
def update_coach(
    id_coach: int,
    coach: CoachUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    """
    Met à jour un coach.
    """

    updated = coach_service.update_coach(
        db,
        id_coach,
        coach,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach introuvable.",
        )

    return updated


# ==========================
# DELETE
# ==========================

@router.delete(
    "/{id_coach}",
    status_code=status.HTTP_200_OK,
)
def delete_coach(
    id_coach: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    """
    Supprime un coach.
    """

    deleted = coach_service.delete_coach(
        db,
        id_coach,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Coach introuvable.",
        )

    return {
        "message": "Coach supprimé avec succès."
    }