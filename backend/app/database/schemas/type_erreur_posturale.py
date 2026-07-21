from pydantic import BaseModel, ConfigDict

from app.database.models.type_erreur_posturale import NiveauRisqueEnum


class TypeErreurPosturaleBase(BaseModel):
    code: str
    nom: str
    description: str | None = None
    niveau_risque: NiveauRisqueEnum | None = None


class TypeErreurPosturaleCreate(TypeErreurPosturaleBase):
    """Données nécessaires pour créer un type d'erreur posturale."""
    pass


class TypeErreurPosturaleUpdate(BaseModel):
    """Mise à jour partielle d'un type d'erreur posturale."""

    code: str | None = None
    nom: str | None = None
    description: str | None = None
    niveau_risque: NiveauRisqueEnum | None = None


class TypeErreurPosturaleRead(TypeErreurPosturaleBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_type_erreur: int