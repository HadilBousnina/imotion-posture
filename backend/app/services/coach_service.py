from sqlalchemy.orm import Session

from app.crud import coach as coach_crud
from app.database.schemas.coach import (
    CoachCreate,
    CoachUpdate,
)


def get_all_coachs(db: Session):
    return coach_crud.get_coachs(db)


def get_coach(
    db: Session,
    id_coach: int,
):
    return coach_crud.get_coach(
        db,
        id_coach,
    )


def create_coach(
    db: Session,
    coach: CoachCreate,
):
    return coach_crud.create_coach(
        db,
        coach,
    )


def update_coach(
    db: Session,
    id_coach: int,
    coach: CoachUpdate,
):
    return coach_crud.update_coach(
        db,
        id_coach,
        coach,
    )


def delete_coach(
    db: Session,
    id_coach: int,
):
    return coach_crud.delete_coach(
        db,
        id_coach,
    )