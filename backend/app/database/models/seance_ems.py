from sqlalchemy import Column, Integer, String, Float, DateTime, Text, ForeignKey
from sqlalchemy.orm import relationship

from app.database.database import Base


class SeanceEms(Base):
    __tablename__ = "seances_ems"

    id_seance = Column(Integer, primary_key=True, autoincrement=True)
    date_debut = Column(DateTime, nullable=False)
    date_fin = Column(DateTime, nullable=True)
    duree = Column(Integer, nullable=True)  # en secondes
    score_global = Column(Float, nullable=True)  # 0-100
    commentaire = Column(Text, nullable=True)

    # FK
    id_adherent = Column(Integer, ForeignKey("adherents.id_adherent"), nullable=False)
    id_coach = Column(Integer, ForeignKey("coachs.id_coach"), nullable=False)

    # Relations
    adherent = relationship("Adherent", back_populates="seances_ems")
    coach = relationship("Coach", back_populates="seances_ems")
    seances_exercices = relationship(
        "SeanceExercice", back_populates="seance", cascade="all, delete-orphan"
    )