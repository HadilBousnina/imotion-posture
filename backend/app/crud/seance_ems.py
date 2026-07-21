from sqlalchemy.orm import Session

from app.database.models.seance_ems import SeanceEms
from app.database.schemas.seance_ems import SeanceEmsCreate, SeanceEmsUpdate


# READ ALL
def get_seances_ems(db: Session):
    return db.query(SeanceEms).all()


# READ ONE
def get_seance_ems(db: Session, id_seance: int):
    return (
        db.query(SeanceEms)
        .filter(SeanceEms.id_seance == id_seance)
        .first()
    )


# CREATE
def create_seance_ems(db: Session, seance: SeanceEmsCreate):

    db_seance = SeanceEms(
        date_debut=seance.date_debut,
        date_fin=seance.date_fin,
        duree=seance.duree,
        score_global=seance.score_global,
        commentaire=seance.commentaire,
        id_adherent=seance.id_adherent,
        id_coach=seance.id_coach,
    )

    db.add(db_seance)
    db.commit()
    db.refresh(db_seance)

    return db_seance


# UPDATE
def update_seance_ems(
    db: Session,
    id_seance: int,
    seance: SeanceEmsUpdate,
):

    db_seance = get_seance_ems(db, id_seance)

    if not db_seance:
        return None

    update_data = seance.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_seance, key, value)

    db.commit()
    db.refresh(db_seance)

    return db_seance


# DELETE
def delete_seance_ems(db: Session, id_seance: int):

    db_seance = get_seance_ems(db, id_seance)

    if not db_seance:
        return None

    db.delete(db_seance)
    db.commit()

    return db_seance