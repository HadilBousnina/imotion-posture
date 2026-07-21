from sqlalchemy.orm import Session

from app.crud import seance_ems as seance_ems_crud
from app.database.schemas.seance_ems import (
    SeanceEmsCreate,
    SeanceEmsUpdate,
)


def get_all_seances_ems(db: Session):
    return seance_ems_crud.get_seances_ems(db)


def get_seance_ems(
    db: Session,
    id_seance: int,
):
    return seance_ems_crud.get_seance_ems(
        db,
        id_seance,
    )


def create_seance_ems(
    db: Session,
    seance: SeanceEmsCreate,
):
    return seance_ems_crud.create_seance_ems(
        db,
        seance,
    )


def update_seance_ems(
    db: Session,
    id_seance: int,
    seance: SeanceEmsUpdate,
):
    return seance_ems_crud.update_seance_ems(
        db,
        id_seance,
        seance,
    )


def delete_seance_ems(
    db: Session,
    id_seance: int,
):
    return seance_ems_crud.delete_seance_ems(
        db,
        id_seance,
    )