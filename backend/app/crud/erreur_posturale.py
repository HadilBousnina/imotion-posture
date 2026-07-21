from sqlalchemy.orm import Session

from app.database.models.erreur_posturale import ErreurPosturale
from app.database.schemas.erreur_posturale import (
    ErreurPosturaleCreate,
    ErreurPosturaleUpdate,
)


def get_erreurs_posturales(db: Session):
    return db.query(ErreurPosturale).all()


def get_erreur_posturale(db: Session, id_erreur: int):
    return (
        db.query(ErreurPosturale)
        .filter(ErreurPosturale.id_erreur == id_erreur)
        .first()
    )


def create_erreur_posturale(
    db: Session,
    erreur: ErreurPosturaleCreate,
):

    db_erreur = ErreurPosturale(
        gravite=erreur.gravite,
        id_repetition=erreur.id_repetition,
        id_type_erreur=erreur.id_type_erreur,
    )

    db.add(db_erreur)
    db.commit()
    db.refresh(db_erreur)

    return db_erreur


def update_erreur_posturale(
    db: Session,
    id_erreur: int,
    erreur: ErreurPosturaleUpdate,
):

    db_erreur = get_erreur_posturale(db, id_erreur)

    if not db_erreur:
        return None

    update_data = erreur.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_erreur, key, value)

    db.commit()
    db.refresh(db_erreur)

    return db_erreur


def delete_erreur_posturale(db: Session, id_erreur: int):

    db_erreur = get_erreur_posturale(db, id_erreur)

    if not db_erreur:
        return None

    db.delete(db_erreur)
    db.commit()

    return db_erreur