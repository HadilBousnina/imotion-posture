from pydantic import BaseModel, ConfigDict


class MesureBiomecaniqueBase(BaseModel):
    angle_genou_gauche: float | None = None
    angle_genou_droit: float | None = None
    angle_hanche: float | None = None
    angle_tronc: float | None = None
    distance_genoux: float | None = None
    stabilite: float | None = None
    alignement_colonne: float | None = None
    id_repetition: int


class MesureBiomecaniqueCreate(MesureBiomecaniqueBase):
    """Données nécessaires pour enregistrer les mesures biomécaniques."""
    pass


class MesureBiomecaniqueUpdate(BaseModel):
    """Mise à jour partielle des mesures biomécaniques."""

    angle_genou_gauche: float | None = None
    angle_genou_droit: float | None = None
    angle_hanche: float | None = None
    angle_tronc: float | None = None
    distance_genoux: float | None = None
    stabilite: float | None = None
    alignement_colonne: float | None = None
    id_repetition: int | None = None


class MesureBiomecaniqueRead(MesureBiomecaniqueBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_mesure: int