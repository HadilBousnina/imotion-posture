from sqlalchemy.orm import Session

from app.database.models.exercice import Exercice
from app.database.schemas.exercice import ExerciceCreate, ExerciceUpdate


# READ ALL
def get_exercices(db: Session):
    return db.query(Exercice).all()


# READ ONE
def get_exercice(db: Session, id_exercice: int):
    return (
        db.query(Exercice)
        .filter(Exercice.id_exercice == id_exercice)
        .first()
    )


# CREATE
def create_exercice(db: Session, exercice: ExerciceCreate):

    db_exercice = Exercice(
        nom=exercice.nom,
        description=exercice.description,
        muscle_principal=exercice.muscle_principal,
    )

    db.add(db_exercice)
    db.commit()
    db.refresh(db_exercice)

    return db_exercice


# UPDATE
def update_exercice(
    db: Session,
    id_exercice: int,
    exercice: ExerciceUpdate,
):

    db_exercice = get_exercice(db, id_exercice)

    if not db_exercice:
        return None

    update_data = exercice.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_exercice, key, value)

    db.commit()
    db.refresh(db_exercice)

    return db_exercice


# DELETE
def delete_exercice(db: Session, id_exercice: int):

    db_exercice = get_exercice(db, id_exercice)

    if not db_exercice:
        return None

    db.delete(db_exercice)
    db.commit()

    return db_exercice