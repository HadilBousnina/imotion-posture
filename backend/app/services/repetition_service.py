from sqlalchemy.orm import Session

from app.crud import repetition as repetition_crud
from app.database.schemas.repetition import (
    RepetitionCreate,
    RepetitionUpdate,
)


def get_all_repetitions(db: Session):
    return repetition_crud.get_repetitions(db)


def get_repetition(
    db: Session,
    id_repetition: int,
):
    return repetition_crud.get_repetition(
        db,
        id_repetition,
    )


def create_repetition(
    db: Session,
    repetition: RepetitionCreate,
):
    return repetition_crud.create_repetition(
        db,
        repetition,
    )


def update_repetition(
    db: Session,
    id_repetition: int,
    repetition: RepetitionUpdate,
):
    return repetition_crud.update_repetition(
        db,
        id_repetition,
        repetition,
    )


def delete_repetition(
    db: Session,
    id_repetition: int,
):
    return repetition_crud.delete_repetition(
        db,
        id_repetition,
    )