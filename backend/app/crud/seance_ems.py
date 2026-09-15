from sqlalchemy.orm import Session

from app.database.models.seance_ems import SeanceEms
from app.database.schemas.seance_ems import (
    SeanceEmsCreate,
    SeanceEmsUpdate,
)


# =========================================================
# READ ALL — séances du coach connecté
# =========================================================

def get_seances_ems(
    db: Session,
    id_coach: int,
):
    return (
        db.query(SeanceEms)
        .filter(
            SeanceEms.id_coach == id_coach
        )
        .all()
    )


# =========================================================
# READ ONE — uniquement si la séance appartient au coach
# =========================================================

def get_seance_ems(
    db: Session,
    id_seance: int,
    id_coach: int,
):
    return (
        db.query(SeanceEms)
        .filter(
            SeanceEms.id_seance == id_seance,
            SeanceEms.id_coach == id_coach,
        )
        .first()
    )


# =========================================================
# CREATE
# =========================================================

def create_seance_ems(
    db: Session,
    seance: SeanceEmsCreate,
    id_coach: int,
):
    db_seance = SeanceEms(
        date_debut=seance.date_debut,
        date_fin=seance.date_fin,
        duree=seance.duree,
        score_global=seance.score_global,
        commentaire=seance.commentaire,
        id_adherent=seance.id_adherent,
        id_coach=id_coach,
    )

    db.add(db_seance)
    db.commit()
    db.refresh(db_seance)

    return db_seance


# =========================================================
# UPDATE
# =========================================================

def update_seance_ems(
    db: Session,
    id_seance: int,
    seance: SeanceEmsUpdate,
    id_coach: int,
):
    db_seance = get_seance_ems(
        db,
        id_seance,
        id_coach,
    )

    if not db_seance:
        return None

    update_data = seance.model_dump(
        exclude_unset=True
    )

    for key, value in update_data.items():
        setattr(
            db_seance,
            key,
            value,
        )

    db.commit()
    db.refresh(db_seance)

    return db_seance


# =========================================================
# DELETE
# =========================================================

def delete_seance_ems(
    db: Session,
    id_seance: int,
    id_coach: int,
):
    db_seance = get_seance_ems(
        db,
        id_seance,
        id_coach,
    )

    if not db_seance:
        return None

    db.delete(db_seance)
    db.commit()

    return db_seance