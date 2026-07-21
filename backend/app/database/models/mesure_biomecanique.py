from sqlalchemy import Column, Integer, Float, ForeignKey
from sqlalchemy.orm import relationship

from app.database.database import Base


class MesureBiomecanique(Base):
    """
    Features biomécaniques calculées à partir des landmarks MediaPipe.
    Ce sont exactement les features utilisées par le modèle ML.
    """

    __tablename__ = "mesures_biomecaniques"

    id_mesure = Column(Integer, primary_key=True, autoincrement=True)
    angle_genou_gauche = Column(Float, nullable=True)
    angle_genou_droit = Column(Float, nullable=True)
    angle_hanche = Column(Float, nullable=True)
    angle_tronc = Column(Float, nullable=True)
    distance_genoux = Column(Float, nullable=True)
    stabilite = Column(Float, nullable=True)
    alignement_colonne = Column(Float, nullable=True)

    # FK
    id_repetition = Column(Integer, ForeignKey("repetitions.id_repetition"), nullable=False)

    # Relations
    repetition = relationship("Repetition", back_populates="mesures_biomecaniques")