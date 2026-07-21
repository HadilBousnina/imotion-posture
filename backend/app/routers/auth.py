from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.dependencies import get_current_user
from app.database.models.coach import Coach

from app.database.database import get_db
from app.database.schemas.coach import CoachCreate, CoachRead
from fastapi.security import OAuth2PasswordRequestForm
from app.database.schemas.auth import Token

from app.services.auth_service import (
    register_coach,
    login_coach,
)

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


@router.post(
    "/register",
    response_model=CoachRead,
    status_code=status.HTTP_201_CREATED,
)
def register(
    coach: CoachCreate,
    db: Session = Depends(get_db),
):
    """
    Inscription d'un nouveau coach.
    """

    new_coach = register_coach(
        db,
        coach,
    )

    if new_coach is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cet email est déjà utilisé.",
        )

    return new_coach


@router.post(
    "/login",
    response_model=Token,
)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    """
    Connexion d'un coach.
    """

    token = login_coach(
    db,
    form_data.username,
    form_data.password,
)

    if token is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect.",
        )

    return token
@router.get(
    "/me",
    response_model=CoachRead,
)
def get_me(
    current_user: Coach = Depends(get_current_user),
):
    """
    Retourne les informations du coach connecté.
    """

    return current_user