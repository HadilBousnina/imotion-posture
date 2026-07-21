from sqlalchemy.orm import Session

from app.database.models.type_erreur_posturale import TypeErreurPosturale
from app.database.schemas.type_erreur_posturale import (
    TypeErreurPosturaleCreate,
    TypeErreurPosturaleUpdate,
)


def get_types_erreurs_posturales(db: Session):
    return db.query(TypeErreurPosturale).all()


def get_type_erreur_posturale(db: Session, id_type_erreur: int):
    return (
        db.query(TypeErreurPosturale)
        .filter(TypeErreurPosturale.id_type_erreur == id_type_erreur)
        .first()
    )


def create_type_erreur_posturale(
    db: Session,
    type_erreur: TypeErreurPosturaleCreate,
):

    db_type = TypeErreurPosturale(
        code=type_erreur.code,
        nom=type_erreur.nom,
        description=type_erreur.description,
        niveau_risque=type_erreur.niveau_risque,
    )

    db.add(db_type)
    db.commit()
    db.refresh(db_type)

    return db_type


def update_type_erreur_posturale(
    db: Session,
    id_type_erreur: int,
    type_erreur: TypeErreurPosturaleUpdate,
):

    db_type = get_type_erreur_posturale(db, id_type_erreur)

    if not db_type:
        return None

    update_data = type_erreur.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_type, key, value)

    db.commit()
    db.refresh(db_type)

    return db_type


def delete_type_erreur_posturale(db: Session, id_type_erreur: int):

    db_type = get_type_erreur_posturale(db, id_type_erreur)

    if not db_type:
        return None

    db.delete(db_type)
    db.commit()

    return db_type