from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
)
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.database.models.coach import Coach
from app.database.schemas.analyse_posturale import (
    AnalysePosturaleCreate,
    AnalysePosturaleUpdate,
    AnalysePosturaleRead,
)
from app.core.dependencies import get_current_user
from app.services import analyse_posturale_service

router = APIRouter(
    prefix="/analyses-posturales",
    tags=["Analyses Posturales"],
)

@router.get(
    "/",
    response_model=list[AnalysePosturaleRead],
)
def get_all_analyses_posturales(
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return analyse_posturale_service.get_all_analyses_posturales(db)

@router.get(
    "/{id_analyse}",
    response_model=AnalysePosturaleRead,
)
def get_analyse_posturale(
    id_analyse: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    analyse = analyse_posturale_service.get_analyse_posturale(
        db,
        id_analyse,
    )

    if analyse is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Analyse posturale introuvable.",
        )

    return analyse

@router.post(
    "/",
    response_model=AnalysePosturaleRead,
    status_code=status.HTTP_201_CREATED,
)
def create_analyse_posturale(
    analyse: AnalysePosturaleCreate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    return analyse_posturale_service.create_analyse_posturale(
        db,
        analyse,
    )
    
@router.put(
    "/{id_analyse}",
    response_model=AnalysePosturaleRead,
)
def update_analyse_posturale(
    id_analyse: int,
    analyse: AnalysePosturaleUpdate,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    updated = analyse_posturale_service.update_analyse_posturale(
        db,
        id_analyse,
        analyse,
    )

    if updated is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Analyse posturale introuvable.",
        )

    return updated

@router.delete(
    "/{id_analyse}",
)
def delete_analyse_posturale(
    id_analyse: int,
    db: Session = Depends(get_db),
    current_user: Coach = Depends(get_current_user),
):
    deleted = analyse_posturale_service.delete_analyse_posturale(
        db,
        id_analyse,
    )

    if deleted is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Analyse posturale introuvable.",
        )

    return {
        "message": "Analyse posturale supprimée avec succès."
    }
    
