from sqlalchemy.orm import Session

from app.crud import adherent as adherent_crud
from app.database.schemas.adherent import (
    AdherentCreate,
    AdherentUpdate,
)


def get_all_adherents(db: Session):
    return adherent_crud.get_adherents(db)


def get_adherent(
    db: Session,
    id_adherent: int,
):
    return adherent_crud.get_adherent(
        db,
        id_adherent,
    )


def create_adherent(
    db: Session,
    adherent: AdherentCreate,
):
    return adherent_crud.create_adherent(
        db,
        adherent,
    )


def update_adherent(
    db: Session,
    id_adherent: int,
    adherent: AdherentUpdate,
):
    return adherent_crud.update_adherent(
        db,
        id_adherent,
        adherent,
    )


def delete_adherent(
    db: Session,
    id_adherent: int,
):
    return adherent_crud.delete_adherent(
        db,
        id_adherent,
    )
    