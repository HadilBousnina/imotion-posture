from sqlalchemy.orm import Session

from app.crud import seance_ems as seance_ems_crud

from app.database.schemas.seance_ems import (
    SeanceEmsCreate,
    SeanceEmsUpdate,
)


# =========================================================
# READ ALL
# =========================================================

def get_all_seances_ems(
    db: Session,
    id_coach: int,
):
    return seance_ems_crud.get_seances_ems(
        db,
        id_coach,
    )


# =========================================================
# READ ONE
# =========================================================

def get_seance_ems(
    db: Session,
    id_seance: int,
    id_coach: int,
):
    return seance_ems_crud.get_seance_ems(
        db,
        id_seance,
        id_coach,
    )


# =========================================================
# CREATE
# =========================================================

def create_seance_ems(
    db: Session,
    seance: SeanceEmsCreate,
    id_coach: int,
):
    return seance_ems_crud.create_seance_ems(
        db,
        seance,
        id_coach,
    )


# =========================================================
# UPDATE
# =========================================================

def update_seance_ems(
    db: Session,
    id_seance: int,
    seance: SeanceEmsUpdate,
    id_coach: int,
):
    return seance_ems_crud.update_seance_ems(
        db,
        id_seance,
        seance,
        id_coach,
    )


# =========================================================
# DELETE
# =========================================================

def delete_seance_ems(
    db: Session,
    id_seance: int,
    id_coach: int,
):
    return seance_ems_crud.delete_seance_ems(
        db,
        id_seance,
        id_coach,
    )