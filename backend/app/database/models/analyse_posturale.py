from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.database.database import Base


class AnalysePosturale(Base):
    __tablename__ = "analyses_posturales"

    id_analyse = Column(Integer, primary_key=True, autoincrement=True)
    modele_utilise = Column(String(100), nullable=True)  # ex: "MediaPipe Pose"
    score_posture = Column(Float, nullable=True)
    temps_execution = Column(Float, nullable=True)  # en ms
    date_analyse = Column(DateTime, server_default=func.now())

    # FK
    id_repetition = Column(Integer, ForeignKey("repetitions.id_repetition"), nullable=False)

    # Relations
    repetition = relationship("Repetition", back_populates="analyses_posturales")