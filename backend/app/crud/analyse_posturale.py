from sqlalchemy.orm import Session

from app.database.models.analyse_posturale import AnalysePosturale
from app.database.schemas.analyse_posturale import (
    AnalysePosturaleCreate,
    AnalysePosturaleUpdate,
)


def get_analyses_posturales(db: Session):
    return db.query(AnalysePosturale).all()


def get_analyse_posturale(db: Session, id_analyse: int):
    return (
        db.query(AnalysePosturale)
        .filter(AnalysePosturale.id_analyse == id_analyse)
        .first()
    )


def create_analyse_posturale(
    db: Session,
    analyse: AnalysePosturaleCreate,
):

    db_analyse = AnalysePosturale(
        modele_utilise=analyse.modele_utilise,
        score_posture=analyse.score_posture,
        temps_execution=analyse.temps_execution,
        date_analyse=analyse.date_analyse,
        id_repetition=analyse.id_repetition,
    )

    db.add(db_analyse)
    db.commit()
    db.refresh(db_analyse)

    return db_analyse


def update_analyse_posturale(
    db: Session,
    id_analyse: int,
    analyse: AnalysePosturaleUpdate,
):

    db_analyse = get_analyse_posturale(db, id_analyse)

    if not db_analyse:
        return None

    update_data = analyse.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_analyse, key, value)

    db.commit()
    db.refresh(db_analyse)

    return db_analyse


def delete_analyse_posturale(db: Session, id_analyse: int):

    db_analyse = get_analyse_posturale(db, id_analyse)

    if not db_analyse:
        return None

    db.delete(db_analyse)
    db.commit()

    return db_analyse