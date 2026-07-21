from sqlalchemy import Column, Integer, String, Date, Float, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum

from app.database.database import Base


class SexeEnum(str, enum.Enum):
    M = "M"
    F = "F"


class Adherent(Base):
    __tablename__ = "adherents"

    id_adherent = Column(Integer, primary_key=True, autoincrement=True)
    nom = Column(String(100), nullable=False)
    prenom = Column(String(100), nullable=False)
    date_naissance = Column(Date, nullable=True)
    sexe = Column(Enum(SexeEnum), nullable=True)
    taille = Column(Float, nullable=True)  # en cm
    poids = Column(Float, nullable=True)  # en kg
    telephone = Column(String(20), nullable=True)
    objectif = Column(String(255), nullable=True)
    created_at = Column(DateTime, server_default=func.now())

    # FK
    id_coach = Column(Integer, ForeignKey("coachs.id_coach"), nullable=False)

    # Relations
    coach = relationship("Coach", back_populates="adherents")
    seances_ems = relationship("SeanceEms", back_populates="adherent")