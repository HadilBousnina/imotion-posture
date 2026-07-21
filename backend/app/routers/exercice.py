from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.exercice import (
    ExerciceCreate,
    ExerciceUpdate,
    ExerciceRead,
)
from app.core.dependencies import get_current_user
from app.services import exercice_service

router = APIRouter(
    prefix="/exercices",
    tags=["Exercices"],
)
@router.get(
    "/",
    response_model=list[ExerciceRead],
)
def get_all_exercices(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return exercice_service.get_all_exercices(db)

@router.get(
    "/{id_exercice}",
    response_model=ExerciceRead,
)
def get_exercice(
    id_exercice: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    exercice = exercice_service.get_exercice(
        db,
        id_exercice,
    )

    if exercice is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Exercice introuvable.",
        )

    return exercice

@router.post(
    "/",
    response_model=ExerciceRead,
    status_code=status.HTTP_201_CREATED,
)
def create_exercice(
    exercice: ExerciceCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return exercice_service.create_exercice(
        db,
        exercice,
    )
    
@router.put(
    "/{id_exercice}",
    response_model=ExerciceRead,
)
def update_exercice(
    id_exercice: int,
    exercice: ExerciceUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = exercice_service.update_exercice(
        db,
        id_exercice,
        exercice,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Exercice introuvable.",
        )

    return updated

@router.delete(
    "/{id_exercice}",
)
def delete_exercice(
    id_exercice: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = exercice_service.delete_exercice(
        db,
        id_exercice,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Exercice introuvable.",
        )

    return {
        "message": "Exercice supprimé avec succès."
    }
          