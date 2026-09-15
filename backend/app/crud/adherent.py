from sqlalchemy.orm import Session

from app.database.models.adherent import Adherent
from app.database.schemas.adherent import AdherentCreate, AdherentUpdate


# =========================================================
# READ ALL
# =========================================================

def get_adherents(
    db: Session,
    id_coach: int,
):
    return (
        db.query(Adherent)
        .filter(Adherent.id_coach == id_coach)
        .all()
    )


# =========================================================
# READ ONE
# =========================================================

def get_adherent(
    db: Session,
    id_adherent: int,
    id_coach: int,
):
    return (
        db.query(Adherent)
        .filter(
            Adherent.id_adherent == id_adherent,
            Adherent.id_coach == id_coach,
        )
        .first()
    )


# =========================================================
# CREATE
# =========================================================

def create_adherent(
    db: Session,
    adherent: AdherentCreate,
    id_coach: int,
):
    db_adherent = Adherent(
        nom=adherent.nom,
        prenom=adherent.prenom,
        date_naissance=adherent.date_naissance,
        sexe=adherent.sexe,
        taille=adherent.taille,
        poids=adherent.poids,
        telephone=adherent.telephone,
        objectif=adherent.objectif,

        # Le backend impose le coach authentifié
        id_coach=id_coach,
    )

    db.add(db_adherent)
    db.commit()
    db.refresh(db_adherent)

    return db_adherent


# =========================================================
# UPDATE
# =========================================================

def update_adherent(
    db: Session,
    id_adherent: int,
    adherent: AdherentUpdate,
    id_coach: int,
):
    db_adherent = get_adherent(
        db,
        id_adherent,
        id_coach,
    )

    if not db_adherent:
        return None

    update_data = adherent.model_dump(
        exclude_unset=True
    )

    for key, value in update_data.items():
        setattr(db_adherent, key, value)

    db.commit()
    db.refresh(db_adherent)

    return db_adherent


# =========================================================
# DELETE
# =========================================================

def delete_adherent(
    db: Session,
    id_adherent: int,
    id_coach: int,
):
    db_adherent = get_adherent(
        db,
        id_adherent,
        id_coach,
    )

    if not db_adherent:
        return None

    db.delete(db_adherent)
    db.commit()

    return db_adherent