from datetime import datetime
from pydantic import BaseModel, ConfigDict


class SeanceEmsBase(BaseModel):
    date_debut: datetime
    date_fin: datetime | None = None
    duree: int | None = None
    score_global: float | None = None
    commentaire: str | None = None
    id_adherent: int
    id_coach: int


class SeanceEmsCreate(SeanceEmsBase):
    """Données nécessaires pour créer une séance EMS."""
    pass


class SeanceEmsUpdate(BaseModel):
    """Mise à jour partielle d'une séance EMS."""

    date_debut: datetime | None = None
    date_fin: datetime | None = None
    duree: int | None = None
    score_global: float | None = None
    commentaire: str | None = None
    id_adherent: int | None = None
    id_coach: int | None = None


class SeanceEmsRead(SeanceEmsBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_seance: int