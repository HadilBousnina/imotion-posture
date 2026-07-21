from datetime import datetime
from pydantic import BaseModel, ConfigDict


class AnalysePosturaleBase(BaseModel):
    modele_utilise: str | None = None
    score_posture: float | None = None
    temps_execution: float | None = None
    date_analyse: datetime | None = None
    id_repetition: int


class AnalysePosturaleCreate(AnalysePosturaleBase):
    """Données nécessaires pour créer une analyse posturale."""
    pass


class AnalysePosturaleUpdate(BaseModel):
    """Mise à jour partielle d'une analyse posturale."""

    modele_utilise: str | None = None
    score_posture: float | None = None
    temps_execution: float | None = None
    date_analyse: datetime | None = None
    id_repetition: int | None = None


class AnalysePosturaleRead(AnalysePosturaleBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_analyse: int