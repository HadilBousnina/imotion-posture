from sqlalchemy.orm import Session

from app.crud import analyse_posturale as analyse_crud
from app.database.schemas.analyse_posturale import (
    AnalysePosturaleCreate,
    AnalysePosturaleUpdate,
)


def get_all_analyses_posturales(db: Session):
    return analyse_crud.get_analyses_posturales(db)


def get_analyse_posturale(
    db: Session,
    id_analyse: int,
):
    return analyse_crud.get_analyse_posturale(
        db,
        id_analyse,
    )


def create_analyse_posturale(
    db: Session,
    analyse: AnalysePosturaleCreate,
):
    return analyse_crud.create_analyse_posturale(
        db,
        analyse,
    )


def update_analyse_posturale(
    db: Session,
    id_analyse: int,
    analyse: AnalysePosturaleUpdate,
):
    return analyse_crud.update_analyse_posturale(
        db,
        id_analyse,
        analyse,
    )


def delete_analyse_posturale(
    db: Session,
    id_analyse: int,
):
    return analyse_crud.delete_analyse_posturale(
        db,
        id_analyse,
    )