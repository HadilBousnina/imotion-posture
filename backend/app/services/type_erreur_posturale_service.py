from sqlalchemy.orm import Session

from app.crud import type_erreur_posturale as type_erreur_crud
from app.database.schemas.type_erreur_posturale import (
    TypeErreurPosturaleCreate,
    TypeErreurPosturaleUpdate,
)


def get_all_types_erreurs_posturales(db: Session):
    return type_erreur_crud.get_types_erreurs_posturales(db)


def get_type_erreur_posturale(
    db: Session,
    id_type_erreur: int,
):
    return type_erreur_crud.get_type_erreur_posturale(
        db,
        id_type_erreur,
    )


def create_type_erreur_posturale(
    db: Session,
    type_erreur: TypeErreurPosturaleCreate,
):
    return type_erreur_crud.create_type_erreur_posturale(
        db,
        type_erreur,
    )


def update_type_erreur_posturale(
    db: Session,
    id_type_erreur: int,
    type_erreur: TypeErreurPosturaleUpdate,
):
    return type_erreur_crud.update_type_erreur_posturale(
        db,
        id_type_erreur,
        type_erreur,
    )


def delete_type_erreur_posturale(
    db: Session,
    id_type_erreur: int,
):
    return type_erreur_crud.delete_type_erreur_posturale(
        db,
        id_type_erreur,
    )