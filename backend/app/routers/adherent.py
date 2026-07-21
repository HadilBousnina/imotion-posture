from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.adherent import (
    AdherentCreate,
    AdherentUpdate,
    AdherentRead,
)
from app.core.dependencies import get_current_user
from app.services import adherent_service

router = APIRouter(
    prefix="/adherents",
    tags=["Adherents"],
)

@router.get(
    "/",
    response_model=list[AdherentRead],
)
def get_all_adherents(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return adherent_service.get_all_adherents(db)

@router.get(
    "/{id_adherent}",
    response_model=AdherentRead,
)
def get_adherent(
    id_adherent: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    adherent = adherent_service.get_adherent(
        db,
        id_adherent,
    )

    if adherent is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Adhérent introuvable.",
        )

    return adherent

@router.post(
    "/",
    response_model=AdherentRead,
    status_code=status.HTTP_201_CREATED,
)
def create_adherent(
    adherent: AdherentCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return adherent_service.create_adherent(
        db,
        adherent,
    )
    
@router.put(
    "/{id_adherent}",
    response_model=AdherentRead,
)  
def update_adherent(
    id_adherent: int,
    adherent: AdherentUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = adherent_service.update_adherent(
        db,
        id_adherent,
        adherent,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Adhérent introuvable.",
        )

    return updated
@router.delete(
    "/{id_adherent}",
)
def delete_adherent(
    id_adherent: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = adherent_service.delete_adherent(
        db,
        id_adherent,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Adhérent introuvable.",
        )

    return {
        "message": "Adhérent supprimé avec succès."
    }