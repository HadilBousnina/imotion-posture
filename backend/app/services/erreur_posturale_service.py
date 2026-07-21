from sqlalchemy.orm import Session

from app.crud import erreur_posturale as erreur_crud
from app.database.schemas.erreur_posturale import (
    ErreurPosturaleCreate,
    ErreurPosturaleUpdate,
)


def get_all_erreurs_posturales(db: Session):
    return erreur_crud.get_erreurs_posturales(db)


def get_erreur_posturale(
    db: Session,
    id_erreur: int,
):
    return erreur_crud.get_erreur_posturale(
        db,
        id_erreur,
    )


def create_erreur_posturale(
    db: Session,
    erreur: ErreurPosturaleCreate,
):
    return erreur_crud.create_erreur_posturale(
        db,
        erreur,
    )


def update_erreur_posturale(
    db: Session,
    id_erreur: int,
    erreur: ErreurPosturaleUpdate,
):
    return erreur_crud.update_erreur_posturale(
        db,
        id_erreur,
        erreur,
    )


def delete_erreur_posturale(
    db: Session,
    id_erreur: int,
):
    return erreur_crud.delete_erreur_posturale(
        db,
        id_erreur,
    )