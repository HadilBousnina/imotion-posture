from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship

from app.database.database import Base


class Exercice(Base):
    __tablename__ = "exercices"

    id_exercice = Column(Integer, primary_key=True, autoincrement=True)
    nom = Column(String(100), nullable=False)  # ex: Squat, Fente, Gainage
    description = Column(Text, nullable=True)
    muscle_principal = Column(String(100), nullable=True)

    # Relations
    seances_exercices = relationship("SeanceExercice", back_populates="exercice")