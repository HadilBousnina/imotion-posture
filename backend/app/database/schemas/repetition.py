from datetime import datetime
from pydantic import BaseModel, ConfigDict


class RepetitionBase(BaseModel):
    numero: int
    timestamp_debut: datetime | None = None
    timestamp_fin: datetime | None = None
    score: float | None = None
    prediction: str | None = None
    confiance: float | None = None
    id_seance_exercice: int


class RepetitionCreate(RepetitionBase):
    """Données nécessaires pour créer une répétition."""
    pass


class RepetitionUpdate(BaseModel):
    """Mise à jour partielle d'une répétition."""

    numero: int | None = None
    timestamp_debut: datetime | None = None
    timestamp_fin: datetime | None = None
    score: float | None = None
    prediction: str | None = None
    confiance: float | None = None
    id_seance_exercice: int | None = None


class RepetitionRead(RepetitionBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_repetition: int