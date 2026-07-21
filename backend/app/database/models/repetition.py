from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from app.database.database import Base


class Repetition(Base):
    __tablename__ = "repetitions"

    id_repetition = Column(Integer, primary_key=True, autoincrement=True)
    numero = Column(Integer, nullable=False)  # numéro de la répétition dans l'exercice
    timestamp_debut = Column(DateTime, nullable=True)
    timestamp_fin = Column(DateTime, nullable=True)

    # Sorties du modèle ML (à ne pas confondre avec le score métier)
    score = Column(Float, nullable=True)  # score métier 0-100
    prediction = Column(String(100), nullable=True)  # "correct" / "incorrect"
    confiance = Column(Float, nullable=True)  # confidence du modèle ML

    # FK
    id_seance_exercice = Column(
        Integer, ForeignKey("seances_exercices.id_seance_exercice"), nullable=False
    )

    # Relations
    seance_exercice = relationship("SeanceExercice", back_populates="repetitions")
    analyses_posturales = relationship(
        "AnalysePosturale", back_populates="repetition", cascade="all, delete-orphan"
    )
    mesures_biomecaniques = relationship(
        "MesureBiomecanique", back_populates="repetition", cascade="all, delete-orphan"
    )
    erreurs_posturales = relationship(
        "ErreurPosturale", back_populates="repetition", cascade="all, delete-orphan"
    )