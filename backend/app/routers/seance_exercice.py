from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.seance_exercice import (
    SeanceExerciceCreate,
    SeanceExerciceUpdate,
    SeanceExerciceRead,
)
from app.core.dependencies import get_current_user
from app.services import seance_exercice_service

router = APIRouter(
    prefix="/seances-exercices",
    tags=["Séances Exercices"],
)


@router.get(
    "/",
    response_model=list[SeanceExerciceRead],
)
def get_all_seances_exercices(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return seance_exercice_service.get_all_seances_exercices(db)


@router.get(
    "/{id_seance_exercice}",
    response_model=SeanceExerciceRead,
)
def get_seance_exercice(
    id_seance_exercice: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    seance_exercice = seance_exercice_service.get_seance_exercice(
        db,
        id_seance_exercice,
    )

    if seance_exercice is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance Exercice introuvable.",
        )

    return seance_exercice


@router.post(
    "/",
    response_model=SeanceExerciceRead,
    status_code=status.HTTP_201_CREATED,
)
def create_seance_exercice(
    seance_exercice: SeanceExerciceCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return seance_exercice_service.create_seance_exercice(
        db,
        seance_exercice,
    )


@router.put(
    "/{id_seance_exercice}",
    response_model=SeanceExerciceRead,
)
def update_seance_exercice(
    id_seance_exercice: int,
    seance_exercice: SeanceExerciceUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = seance_exercice_service.update_seance_exercice(
        db,
        id_seance_exercice,
        seance_exercice,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance Exercice introuvable.",
        )

    return updated


@router.delete(
    "/{id_seance_exercice}",
)
def delete_seance_exercice(
    id_seance_exercice: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = seance_exercice_service.delete_seance_exercice(
        db,
        id_seance_exercice,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance Exercice introuvable.",
        )

    return {
        "message": "Séance Exercice supprimée avec succès."
    }