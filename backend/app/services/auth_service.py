from sqlalchemy.orm import Session

from app.crud.coach import (
    create_coach,
    get_coach_by_email,
)
from app.database.schemas.coach import CoachCreate
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
)


def register_coach(
    db: Session,
    coach: CoachCreate,
):
    """
    Inscrit un nouveau coach.
    """

    # Vérifie que l'email n'est pas déjà utilisé
    existing_coach = get_coach_by_email(
        db,
        coach.email,
    )

    if existing_coach:
        return None

    # Hash du mot de passe
    hashed_password = hash_password(
        coach.password
    )

    # Création d'un nouvel objet avec le mot de passe hashé
    coach_data = CoachCreate(
        nom=coach.nom,
        prenom=coach.prenom,
        email=coach.email,
        password=hashed_password,
    )

    return create_coach(
        db,
        coach_data,
    )


def login_coach(
    db: Session,
    email: str,
    password: str,
):
    """
    Authentifie un coach.
    Retourne un JWT si les identifiants sont valides.
    """

    coach = get_coach_by_email(
        db,
        email,
    )

    if coach is None:
        return None

    if not verify_password(
        password,
        coach.password_hash,
    ):
        return None

    access_token = create_access_token(
        data={
            "sub": coach.email,
            "id": coach.id_coach,
        }
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
    }


def authenticate_coach(
    db: Session,
    email: str,
    password: str,
):
    """
    Vérifie simplement les identifiants.
    """

    coach = get_coach_by_email(
        db,
        email,
    )

    if coach is None:
        return None

    if not verify_password(
        password,
        coach.password_hash,
    ):
        return None

    return coach


def get_coach_from_token(
    db: Session,
    email: str,
):
    """
    Retourne le coach associé à un email.
    Cette fonction sera utilisée plus tard
    avec Depends() et OAuth2.
    """

    return get_coach_by_email(
        db,
        email,
    )