from sqlalchemy.orm import Session

from app.database.models.mesure_biomecanique import MesureBiomecanique
from app.database.schemas.mesure_biomecanique import (
    MesureBiomecaniqueCreate,
    MesureBiomecaniqueUpdate,
)


def get_mesures_biomecaniques(db: Session):
    return db.query(MesureBiomecanique).all()


def get_mesure_biomecanique(db: Session, id_mesure: int):
    return (
        db.query(MesureBiomecanique)
        .filter(MesureBiomecanique.id_mesure == id_mesure)
        .first()
    )


def create_mesure_biomecanique(
    db: Session,
    mesure: MesureBiomecaniqueCreate,
):

    db_mesure = MesureBiomecanique(
        angle_genou_gauche=mesure.angle_genou_gauche,
        angle_genou_droit=mesure.angle_genou_droit,
        angle_hanche=mesure.angle_hanche,
        angle_tronc=mesure.angle_tronc,
        distance_genoux=mesure.distance_genoux,
        stabilite=mesure.stabilite,
        alignement_colonne=mesure.alignement_colonne,
        id_repetition=mesure.id_repetition,
    )

    db.add(db_mesure)
    db.commit()
    db.refresh(db_mesure)

    return db_mesure


def update_mesure_biomecanique(
    db: Session,
    id_mesure: int,
    mesure: MesureBiomecaniqueUpdate,
):

    db_mesure = get_mesure_biomecanique(db, id_mesure)

    if not db_mesure:
        return None

    update_data = mesure.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_mesure, key, value)

    db.commit()
    db.refresh(db_mesure)

    return db_mesure


def delete_mesure_biomecanique(db: Session, id_mesure: int):

    db_mesure = get_mesure_biomecanique(db, id_mesure)

    if not db_mesure:
        return None

    db.delete(db_mesure)
    db.commit()

    return db_mesure