from sqlalchemy import Column, Integer, Float, ForeignKey
from sqlalchemy.orm import relationship

from app.database.database import Base


class SeanceExercice(Base):
    __tablename__ = "seances_exercices"

    id_seance_exercice = Column(Integer, primary_key=True, autoincrement=True)
    ordre = Column(Integer, nullable=True)
    score_exercice = Column(Float, nullable=True)

    # FK
    id_seance = Column(Integer, ForeignKey("seances_ems.id_seance"), nullable=False)
    id_exercice = Column(Integer, ForeignKey("exercices.id_exercice"), nullable=False)

    # Relations
    seance = relationship("SeanceEms", back_populates="seances_exercices")
    exercice = relationship("Exercice", back_populates="seances_exercices")
    repetitions = relationship(
        "Repetition", back_populates="seance_exercice", cascade="all, delete-orphan"
    )