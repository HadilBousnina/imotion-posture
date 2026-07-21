from sqlalchemy.orm import Session

from app.database.models.seance_exercice import SeanceExercice
from app.database.schemas.seance_exercice import (
    SeanceExerciceCreate,
    SeanceExerciceUpdate,
)


def get_seances_exercices(db: Session):
    return db.query(SeanceExercice).all()


def get_seance_exercice(db: Session, id_seance_exercice: int):
    return (
        db.query(SeanceExercice)
        .filter(
            SeanceExercice.id_seance_exercice == id_seance_exercice
        )
        .first()
    )


def create_seance_exercice(db: Session, seance_exercice: SeanceExerciceCreate):

    db_seance_exercice = SeanceExercice(
        ordre=seance_exercice.ordre,
        score_exercice=seance_exercice.score_exercice,
        id_seance=seance_exercice.id_seance,
        id_exercice=seance_exercice.id_exercice,
    )

    db.add(db_seance_exercice)
    db.commit()
    db.refresh(db_seance_exercice)

    return db_seance_exercice


def update_seance_exercice(
    db: Session,
    id_seance_exercice: int,
    seance_exercice: SeanceExerciceUpdate,
):

    db_seance_exercice = get_seance_exercice(
        db,
        id_seance_exercice,
    )

    if not db_seance_exercice:
        return None

    update_data = seance_exercice.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_seance_exercice, key, value)

    db.commit()
    db.refresh(db_seance_exercice)

    return db_seance_exercice


def delete_seance_exercice(db: Session, id_seance_exercice: int):

    db_seance_exercice = get_seance_exercice(
        db,
        id_seance_exercice,
    )

    if not db_seance_exercice:
        return None

    db.delete(db_seance_exercice)
    db.commit()

    return db_seance_exercice