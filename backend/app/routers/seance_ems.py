from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.seance_ems import (
    SeanceEmsCreate,
    SeanceEmsUpdate,
    SeanceEmsRead,
)
from app.core.dependencies import get_current_user
from app.services import seance_ems_service

router = APIRouter(
    prefix="/seances-ems",
    tags=["Séances EMS"],
)


@router.get(
    "/",
    response_model=list[SeanceEmsRead],
)
def get_all_seances_ems(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return seance_ems_service.get_all_seances_ems(db)


@router.get(
    "/{id_seance}",
    response_model=SeanceEmsRead,
)
def get_seance_ems(
    id_seance: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    seance = seance_ems_service.get_seance_ems(
        db,
        id_seance,
    )

    if seance is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance EMS introuvable.",
        )

    return seance


@router.post(
    "/",
    response_model=SeanceEmsRead,
    status_code=status.HTTP_201_CREATED,
)
def create_seance_ems(
    seance: SeanceEmsCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return seance_ems_service.create_seance_ems(
        db,
        seance,
    )


@router.put(
    "/{id_seance}",
    response_model=SeanceEmsRead,
)
def update_seance_ems(
    id_seance: int,
    seance: SeanceEmsUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = seance_ems_service.update_seance_ems(
        db,
        id_seance,
        seance,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance EMS introuvable.",
        )

    return updated


@router.delete(
    "/{id_seance}",
)
def delete_seance_ems(
    id_seance: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = seance_ems_service.delete_seance_ems(
        db,
        id_seance,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Séance EMS introuvable.",
        )

    return {
        "message": "Séance EMS supprimée avec succès."
    }