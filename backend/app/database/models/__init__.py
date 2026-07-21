"""
Centralise l'import de tous les modèles pour que Base.metadata les connaisse
(nécessaire pour Base.metadata.create_all() et pour Alembic autogenerate).
"""

from app.database.models.coach import Coach
from app.database.models.adherent import Adherent, SexeEnum
from app.database.models.exercice import Exercice
from app.database.models.seance_ems import SeanceEms
from app.database.models.seance_exercice import SeanceExercice
from app.database.models.repetition import Repetition
from app.database.models.analyse_posturale import AnalysePosturale
from app.database.models.mesure_biomecanique import MesureBiomecanique
from app.database.models.type_erreur_posturale import TypeErreurPosturale, NiveauRisqueEnum
from app.database.models.erreur_posturale import ErreurPosturale

__all__ = [
    "Coach",
    "Adherent",
    "SexeEnum",
    "Exercice",
    "SeanceEms",
    "SeanceExercice",
    "Repetition",
    "AnalysePosturale",
    "MesureBiomecanique",
    "TypeErreurPosturale",
    "NiveauRisqueEnum",
    "ErreurPosturale",
]