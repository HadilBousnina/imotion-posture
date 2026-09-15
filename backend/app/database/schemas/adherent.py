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
    """
    Les informations de l'adhérent.
    Le coach est déterminé par le backend
    à partir du compte authentifié.
    """
    pass


class AdherentUpdate(BaseModel):
    """
    Tous les champs sont optionnels.
    L'appartenance au coach ne peut pas être modifiée.
    """

    nom: str | None = None
    prenom: str | None = None
    date_naissance: date | None = None
    sexe: SexeEnum | None = None
    taille: float | None = None
    poids: float | None = None
    telephone: str | None = None
    objectif: str | None = None


class AdherentRead(AdherentBase):
    model_config = ConfigDict(from_attributes=True)

    id_adherent: int
    id_coach: int
    created_at: datetime