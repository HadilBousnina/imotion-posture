from sqlalchemy.orm import Session

from app.crud import exercice as exercice_crud
from app.database.schemas.exercice import (
    ExerciceCreate,
    ExerciceUpdate,
)


def get_all_exercices(db: Session):
    return exercice_crud.get_exercices(db)


def get_exercice(
    db: Session,
    id_exercice: int,
):
    return exercice_crud.get_exercice(
        db,
        id_exercice,
    )


def create_exercice(
    db: Session,
    exercice: ExerciceCreate,
):
    return exercice_crud.create_exercice(
        db,
        exercice,
    )


def update_exercice(
    db: Session,
    id_exercice: int,
    exercice: ExerciceUpdate,
):
    return exercice_crud.update_exercice(
        db,
        id_exercice,
        exercice,
    )


def delete_exercice(
    db: Session,
    id_exercice: int,
):
    return exercice_crud.delete_exercice(
        db,
        id_exercice,
    )