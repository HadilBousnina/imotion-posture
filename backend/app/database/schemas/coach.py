from datetime import datetime
from pydantic import BaseModel, EmailStr, ConfigDict


class CoachBase(BaseModel):
    nom: str
    prenom: str
    email: EmailStr


class CoachCreate(CoachBase):
    """
    Utilisé lors de l'inscription.

    Le mot de passe est reçu en clair,
    puis hashé dans la couche Service
    avant d'être enregistré en base.
    """

    password: str


class CoachUpdate(BaseModel):
    """Tous les champs optionnels : on ne met à jour que ce qui est fourni."""

    nom: str | None = None
    prenom: str | None = None
    email: EmailStr | None = None
    password: str | None = None


class CoachRead(CoachBase):
    """Ce qui est renvoyé par l'API. Ne contient jamais password_hash."""

    model_config = ConfigDict(from_attributes=True)

    id_coach: int
    created_at: datetime