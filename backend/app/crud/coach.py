from sqlalchemy.orm import Session

from app.database.models.coach import Coach
from app.database.schemas.coach import CoachCreate, CoachUpdate


# READ ALL
def get_coachs(db: Session):
    return db.query(Coach).all()


# READ ONE
def get_coach(db: Session, id_coach: int):
    return (
        db.query(Coach)
        .filter(Coach.id_coach == id_coach)
        .first()
    )
    
def get_coach_by_email(
    db: Session,
    email: str,
):
    return (
        db.query(Coach)
        .filter(Coach.email == email)
        .first()
    )    
# READ BY EMAIL
def get_coach_by_email(
    db: Session,
    email: str,
):
    return (
        db.query(Coach)
        .filter(Coach.email == email)
        .first()
    )

# CREATE
def create_coach(db: Session, coach: CoachCreate):

    db_coach = Coach(
        nom=coach.nom,
        prenom=coach.prenom,
        email=coach.email,
        password_hash=coach.password
    )

    db.add(db_coach)
    db.commit()
    db.refresh(db_coach)

    return db_coach


# UPDATE
def update_coach(
    db: Session,
    id_coach: int,
    coach: CoachUpdate
):

    db_coach = get_coach(db, id_coach)

    if not db_coach:
        return None

    update_data = coach.model_dump(
        exclude_unset=True
    )

    for key, value in update_data.items():
        setattr(db_coach, key, value)

    db.commit()
    db.refresh(db_coach)

    return db_coach


# DELETE
def delete_coach(db: Session, id_coach: int):

    db_coach = get_coach(db, id_coach)

    if not db_coach:
        return None

    db.delete(db_coach)
    db.commit()

    return db_coach