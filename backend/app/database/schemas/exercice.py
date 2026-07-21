from pydantic import BaseModel, ConfigDict


class ExerciceBase(BaseModel):
    nom: str
    description: str | None = None
    muscle_principal: str | None = None


class ExerciceCreate(ExerciceBase):
    """Données nécessaires pour créer un exercice."""
    pass


class ExerciceUpdate(BaseModel):
    """Mise à jour partielle d'un exercice."""

    nom: str | None = None
    description: str | None = None
    muscle_principal: str | None = None


class ExerciceRead(ExerciceBase):
    """Données renvoyées par l'API."""

    model_config = ConfigDict(from_attributes=True)

    id_exercice: int