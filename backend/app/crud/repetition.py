from sqlalchemy.orm import Session

from app.database.models.repetition import Repetition
from app.database.schemas.repetition import RepetitionCreate, RepetitionUpdate


def get_repetitions(db: Session):
    return db.query(Repetition).all()


def get_repetition(db: Session, id_repetition: int):
    return (
        db.query(Repetition)
        .filter(Repetition.id_repetition == id_repetition)
        .first()
    )


def create_repetition(db: Session, repetition: RepetitionCreate):

    db_repetition = Repetition(
        numero=repetition.numero,
        timestamp_debut=repetition.timestamp_debut,
        timestamp_fin=repetition.timestamp_fin,
        score=repetition.score,
        prediction=repetition.prediction,
        confiance=repetition.confiance,
        id_seance_exercice=repetition.id_seance_exercice,
    )

    db.add(db_repetition)
    db.commit()
    db.refresh(db_repetition)

    return db_repetition


def update_repetition(
    db: Session,
    id_repetition: int,
    repetition: RepetitionUpdate,
):

    db_repetition = get_repetition(db, id_repetition)

    if not db_repetition:
        return None

    update_data = repetition.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_repetition, key, value)

    db.commit()
    db.refresh(db_repetition)

    return db_repetition


def delete_repetition(db: Session, id_repetition: int):

    db_repetition = get_repetition(db, id_repetition)

    if not db_repetition:
        return None

    db.delete(db_repetition)
    db.commit()

    return db_repetition