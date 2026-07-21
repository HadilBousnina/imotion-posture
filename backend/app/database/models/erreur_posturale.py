from sqlalchemy import Column, Integer, Float, ForeignKey
from sqlalchemy.orm import relationship

from app.database.database import Base


class ErreurPosturale(Base):
    """
    Enregistre les erreurs detectees pour une repetition donnee.
    Une repetition peut avoir plusieurs erreurs (relation N,1 vers le type d'erreur).
    """

    __tablename__ = "erreurs_posturales"

    id_erreur = Column(Integer, primary_key=True, autoincrement=True)
    gravite = Column(Float, nullable=True)

    # FK
    id_repetition = Column(Integer, ForeignKey("repetitions.id_repetition"), nullable=False)
    id_type_erreur = Column(
        Integer, ForeignKey("types_erreurs_posturales.id_type_erreur"), nullable=False
    )

    # Relations
    repetition = relationship("Repetition", back_populates="erreurs_posturales")
    type_erreur = relationship("TypeErreurPosturale", back_populates="erreurs_posturales")