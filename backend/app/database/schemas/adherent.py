from datetime import datetime, date
from pydantic import BaseModel, ConfigDict

from app.database.models.adherent import SexeEnum


class AdherentBase(BaseModel):
    nom: str
    prenom: str
    date_naissance: date | None = None
    sexe: SexeEnum | None = None
    taille: float | None = None
    poids: float | None = None
    telephone: str | None = None
    objectif: str | None = None


class AdherentCreate(AdherentBase):
    objectif: str | None = None
    id_coach: int


class AdherentUpdate(BaseModel):
    """Tous les champs optionnels : on ne met à jour que ce qui est fourni."""

    nom: str | None = None
    prenom: str | None = None
    date_naissance: date | None = None
    sexe: SexeEnum | None = None
    taille: float | None = None
    poids: float | None = None
    telephone: str | None = None
    objectif: str | None = None
    id_coach: int | None = None


class AdherentRead(AdherentBase):
    model_config = ConfigDict(from_attributes=True)

    id_adherent: int
    id_coach: int
    created_at: datetime