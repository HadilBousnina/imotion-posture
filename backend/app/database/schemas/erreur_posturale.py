from pydantic import BaseModel, ConfigDict


class ErreurPosturaleBase(BaseModel):
    gravite: float | None = None
    id_repetition: int
    id_type_erreur: int


class ErreurPosturaleCreate(ErreurPosturaleBase):
    """Données nécessaires pour enregistrer une erreur posturale détectée."""
    pass


class ErreurPosturaleUpdate(BaseModel):
    """Mise à jour partielle d'une erreur posturale."""

    gravite: float | None = None
    id_repetition: int | None = None
    id_type_erreur: int | None = None


class ErreurPosturaleRead(ErreurPosturaleBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_erreur: int