from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.repetition import (
    RepetitionCreate,
    RepetitionUpdate,
    RepetitionRead,
)
from app.core.dependencies import get_current_user
from app.services import repetition_service

router = APIRouter(
    prefix="/repetitions",
    tags=["Repetitions"],
)


@router.get(
    "/",
    response_model=list[RepetitionRead],
)
def get_all_repetitions(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return repetition_service.get_all_repetitions(db)


@router.get(
    "/{id_repetition}",
    response_model=RepetitionRead,
)
def get_repetition(
    id_repetition: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    repetition = repetition_service.get_repetition(
        db,
        id_repetition,
    )

    if repetition is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Répétition introuvable.",
        )

    return repetition


@router.post(
    "/",
    response_model=RepetitionRead,
    status_code=status.HTTP_201_CREATED,
)
def create_repetition(
    repetition: RepetitionCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return repetition_service.create_repetition(
        db,
        repetition,
    )


@router.put(
    "/{id_repetition}",
    response_model=RepetitionRead,
)
def update_repetition(
    id_repetition: int,
    repetition: RepetitionUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = repetition_service.update_repetition(
        db,
        id_repetition,
        repetition,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Répétition introuvable.",
        )

    return updated


@router.delete(
    "/{id_repetition}",
)
def delete_repetition(
    id_repetition: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = repetition_service.delete_repetition(
        db,
        id_repetition,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Répétition introuvable.",
        )

    return {
        "message": "Répétition supprimée avec succès."
    }