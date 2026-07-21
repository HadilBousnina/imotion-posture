from sqlalchemy import Column, Integer, String, Text, Enum
from sqlalchemy.orm import relationship
import enum

from app.database.database import Base


class NiveauRisqueEnum(str, enum.Enum):
    faible = "faible"
    moyen = "moyen"
    eleve = "eleve"


class TypeErreurPosturale(Base):
    """
    Table catalogue (normalisation).
    Ex: KNEE_VALGUS, BACK_ROUNDING, HEEL_LIFT, FORWARD_LEAN, ASYMMETRY, LIMITED_DEPTH
    """

    __tablename__ = "types_erreurs_posturales"

    id_type_erreur = Column(Integer, primary_key=True, autoincrement=True)
    code = Column(String(50), nullable=False, unique=True)  # ex: KNEE_VALGUS
    nom = Column(String(100), nullable=False)  # ex: Genoux vers l'intérieur
    description = Column(Text, nullable=True)
    niveau_risque = Column(Enum(NiveauRisqueEnum), nullable=True)

    # Relations
    erreurs_posturales = relationship("ErreurPosturale", back_populates="type_erreur")