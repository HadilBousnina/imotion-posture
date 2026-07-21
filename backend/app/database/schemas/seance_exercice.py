from pydantic import BaseModel, ConfigDict


class SeanceExerciceBase(BaseModel):
    ordre: int | None = None
    score_exercice: float | None = None
    id_seance: int
    id_exercice: int


class SeanceExerciceCreate(SeanceExerciceBase):
    """Données nécessaires pour associer un exercice à une séance."""
    pass


class SeanceExerciceUpdate(BaseModel):
    """Mise à jour partielle d'une association séance-exercice."""

    ordre: int | None = None
    score_exercice: float | None = None
    id_seance: int | None = None
    id_exercice: int | None = None


class SeanceExerciceRead(SeanceExerciceBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_seance_exercice: int