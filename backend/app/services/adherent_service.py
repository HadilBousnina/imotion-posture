from sqlalchemy.orm import Session

from app.crud import adherent as adherent_crud

from app.database.schemas.adherent import (
    AdherentCreate,
    AdherentUpdate,
)


def get_all_adherents(
    db: Session,
    id_coach: int,
):
    return adherent_crud.get_adherents(
        db,
        id_coach,
    )


def get_adherent(
    db: Session,
    id_adherent: int,
    id_coach: int,
):
    return adherent_crud.get_adherent(
        db,
        id_adherent,
        id_coach,
    )


def create_adherent(
    db: Session,
    adherent: AdherentCreate,
    id_coach: int,
):
    return adherent_crud.create_adherent(
        db,
        adherent,
        id_coach,
    )


def update_adherent(
    db: Session,
    id_adherent: int,
    adherent: AdherentUpdate,
    id_coach: int,
):
    return adherent_crud.update_adherent(
        db,
        id_adherent,
        adherent,
        id_coach,
    )


def delete_adherent(
    db: Session,
    id_adherent: int,
    id_coach: int,
):
    return adherent_crud.delete_adherent(
        db,
        id_adherent,
        id_coach,
    )