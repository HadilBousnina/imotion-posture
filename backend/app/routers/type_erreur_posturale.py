from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.type_erreur_posturale import (
    TypeErreurPosturaleCreate,
    TypeErreurPosturaleUpdate,
    TypeErreurPosturaleRead,
)
from app.core.dependencies import get_current_user
from app.services import type_erreur_posturale_service

router = APIRouter(
    prefix="/types-erreurs-posturales",
    tags=["Types Erreurs Posturales"],
)


@router.get(
    "/",
    response_model=list[TypeErreurPosturaleRead],
)
def get_all_types_erreurs_posturales(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return type_erreur_posturale_service.get_all_types_erreurs_posturales(db)


@router.get(
    "/{id_type_erreur}",
    response_model=TypeErreurPosturaleRead,
)
def get_type_erreur_posturale(
    id_type_erreur: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    type_erreur = type_erreur_posturale_service.get_type_erreur_posturale(
        db,
        id_type_erreur,
    )

    if type_erreur is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Type d'erreur posturale introuvable.",
        )

    return type_erreur


@router.post(
    "/",
    response_model=TypeErreurPosturaleRead,
    status_code=status.HTTP_201_CREATED,
)
def create_type_erreur_posturale(
    type_erreur: TypeErreurPosturaleCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return type_erreur_posturale_service.create_type_erreur_posturale(
        db,
        type_erreur,
    )


@router.put(
    "/{id_type_erreur}",
    response_model=TypeErreurPosturaleRead,
)
def update_type_erreur_posturale(
    id_type_erreur: int,
    type_erreur: TypeErreurPosturaleUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = type_erreur_posturale_service.update_type_erreur_posturale(
        db,
        id_type_erreur,
        type_erreur,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Type d'erreur posturale introuvable.",
        )

    return updated


@router.delete(
    "/{id_type_erreur}",
)
def delete_type_erreur_posturale(
    id_type_erreur: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = type_erreur_posturale_service.delete_type_erreur_posturale(
        db,
        id_type_erreur,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Type d'erreur posturale introuvable.",
        )

    return {
        "message": "Type d'erreur posturale supprimé avec succès."
    }