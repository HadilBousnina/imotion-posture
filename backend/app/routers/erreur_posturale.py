from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.erreur_posturale import (
    ErreurPosturaleCreate,
    ErreurPosturaleUpdate,
    ErreurPosturaleRead,
)
from app.core.dependencies import get_current_user
from app.services import erreur_posturale_service

router = APIRouter(
    prefix="/erreurs-posturales",
    tags=["Erreurs Posturales"],
)


@router.get(
    "/",
    response_model=list[ErreurPosturaleRead],
)
def get_all_erreurs_posturales(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return erreur_posturale_service.get_all_erreurs_posturales(db)


@router.get(
    "/{id_erreur}",
    response_model=ErreurPosturaleRead,
)
def get_erreur_posturale(
    id_erreur: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    erreur = erreur_posturale_service.get_erreur_posturale(
        db,
        id_erreur,
    )

    if erreur is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Erreur posturale introuvable.",
        )

    return erreur


@router.post(
    "/",
    response_model=ErreurPosturaleRead,
    status_code=status.HTTP_201_CREATED,
)
def create_erreur_posturale(
    erreur: ErreurPosturaleCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return erreur_posturale_service.create_erreur_posturale(
        db,
        erreur,
    )


@router.put(
    "/{id_erreur}",
    response_model=ErreurPosturaleRead,
)
def update_erreur_posturale(
    id_erreur: int,
    erreur: ErreurPosturaleUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = erreur_posturale_service.update_erreur_posturale(
        db,
        id_erreur,
        erreur,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Erreur posturale introuvable.",
        )

    return updated


@router.delete(
    "/{id_erreur}",
)
def delete_erreur_posturale(
    id_erreur: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = erreur_posturale_service.delete_erreur_posturale(
        db,
        id_erreur,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Erreur posturale introuvable.",
        )

    return {
        "message": "Erreur posturale supprimée avec succès."
    }