from sqlalchemy.orm import Session

from app.crud import seance_exercice as seance_exercice_crud
from app.database.schemas.seance_exercice import (
    SeanceExerciceCreate,
    SeanceExerciceUpdate,
)


def get_all_seances_exercices(db: Session):
    return seance_exercice_crud.get_seances_exercices(db)


def get_seance_exercice(
    db: Session,
    id_seance_exercice: int,
):
    return seance_exercice_crud.get_seance_exercice(
        db,
        id_seance_exercice,
    )


def create_seance_exercice(
    db: Session,
    seance_exercice: SeanceExerciceCreate,
):
    return seance_exercice_crud.create_seance_exercice(
        db,
        seance_exercice,
    )


def update_seance_exercice(
    db: Session,
    id_seance_exercice: int,
    seance_exercice: SeanceExerciceUpdate,
):
    return seance_exercice_crud.update_seance_exercice(
        db,
        id_seance_exercice,
        seance_exercice,
    )


def delete_seance_exercice(
    db: Session,
    id_seance_exercice: int,
):
    return seance_exercice_crud.delete_seance_exercice(
        db,
        id_seance_exercice,
    )