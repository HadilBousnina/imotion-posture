from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.mesure_biomecanique import (
    MesureBiomecaniqueCreate,
    MesureBiomecaniqueUpdate,
    MesureBiomecaniqueRead,
)
from app.core.dependencies import get_current_user
from app.services import mesure_biomecanique_service

router = APIRouter(
    prefix="/mesures-biomecaniques",
    tags=["Mesures Biomécaniques"],
)


@router.get(
    "/",
    response_model=list[MesureBiomecaniqueRead],
)
def get_all_mesures_biomecaniques(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return mesure_biomecanique_service.get_all_mesures_biomecaniques(db)


@router.get(
    "/{id_mesure}",
    response_model=MesureBiomecaniqueRead,
)
def get_mesure_biomecanique(
    id_mesure: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    mesure = mesure_biomecanique_service.get_mesure_biomecanique(
        db,
        id_mesure,
    )

    if mesure is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Mesure biomécanique introuvable.",
        )

    return mesure


@router.post(
    "/",
    response_model=MesureBiomecaniqueRead,
    status_code=status.HTTP_201_CREATED,
)
def create_mesure_biomecanique(
    mesure: MesureBiomecaniqueCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return mesure_biomecanique_service.create_mesure_biomecanique(
        db,
        mesure,
    )


@router.put(
    "/{id_mesure}",
    response_model=MesureBiomecaniqueRead,
)
def update_mesure_biomecanique(
    id_mesure: int,
    mesure: MesureBiomecaniqueUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = mesure_biomecanique_service.update_mesure_biomecanique(
        db,
        id_mesure,
        mesure,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Mesure biomécanique introuvable.",
        )

    return updated


@router.delete(
    "/{id_mesure}",
)
def delete_mesure_biomecanique(
    id_mesure: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = mesure_biomecanique_service.delete_mesure_biomecanique(
        db,
        id_mesure,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Mesure biomécanique introuvable.",
        )

    return {
        "message": "Mesure biomécanique supprimée avec succès."
    }