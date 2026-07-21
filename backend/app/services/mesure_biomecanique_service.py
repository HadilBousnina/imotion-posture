from sqlalchemy.orm import Session

from app.crud import mesure_biomecanique as mesure_crud
from app.database.schemas.mesure_biomecanique import (
    MesureBiomecaniqueCreate,
    MesureBiomecaniqueUpdate,
)


def get_all_mesures_biomecaniques(db: Session):
    return mesure_crud.get_mesures_biomecaniques(db)


def get_mesure_biomecanique(
    db: Session,
    id_mesure: int,
):
    return mesure_crud.get_mesure_biomecanique(
        db,
        id_mesure,
    )


def create_mesure_biomecanique(
    db: Session,
    mesure: MesureBiomecaniqueCreate,
):
    return mesure_crud.create_mesure_biomecanique(
        db,
        mesure,
    )


def update_mesure_biomecanique(
    db: Session,
    id_mesure: int,
    mesure: MesureBiomecaniqueUpdate,
):
    return mesure_crud.update_mesure_biomecanique(
        db,
        id_mesure,
        mesure,
    )


def delete_mesure_biomecanique(
    db: Session,
    id_mesure: int,
):
    return mesure_crud.delete_mesure_biomecanique(
        db,
        id_mesure,
    )