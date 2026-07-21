from app.database.schemas.coach import (
    CoachBase,
    CoachCreate,
    CoachUpdate,
    CoachRead,
)

from app.database.schemas.adherent import (
    AdherentBase,
    AdherentCreate,
    AdherentUpdate,
    AdherentRead,
)

from app.database.schemas.exercice import (
    ExerciceBase,
    ExerciceCreate,
    ExerciceUpdate,
    ExerciceRead,
)

from app.database.schemas.seance_ems import (
    SeanceEmsBase,
    SeanceEmsCreate,
    SeanceEmsUpdate,
    SeanceEmsRead,
)

from app.database.schemas.seance_exercice import (
    SeanceExerciceBase,
    SeanceExerciceCreate,
    SeanceExerciceUpdate,
    SeanceExerciceRead,
)

from app.database.schemas.repetition import (
    RepetitionBase,
    RepetitionCreate,
    RepetitionUpdate,
    RepetitionRead,
)

from app.database.schemas.analyse_posturale import (
    AnalysePosturaleBase,
    AnalysePosturaleCreate,
    AnalysePosturaleUpdate,
    AnalysePosturaleRead,
)

from app.database.schemas.mesure_biomecanique import (
    MesureBiomecaniqueBase,
    MesureBiomecaniqueCreate,
    MesureBiomecaniqueUpdate,
    MesureBiomecaniqueRead,
)

from app.database.schemas.type_erreur_posturale import (
    TypeErreurPosturaleBase,
    TypeErreurPosturaleCreate,
    TypeErreurPosturaleUpdate,
    TypeErreurPosturaleRead,
)

from app.database.schemas.erreur_posturale import (
    ErreurPosturaleBase,
    ErreurPosturaleCreate,
    ErreurPosturaleUpdate,
    ErreurPosturaleRead,
)

from app.database.schemas.auth import (
    LoginRequest,
    Token,
    TokenData,
)

__all__ = [
    # Coach
    "CoachBase",
    "CoachCreate",
    "CoachUpdate",
    "CoachRead",

    # Adherent
    "AdherentBase",
    "AdherentCreate",
    "AdherentUpdate",
    "AdherentRead",

    # Exercice
    "ExerciceBase",
    "ExerciceCreate",
    "ExerciceUpdate",
    "ExerciceRead",

    # Seance EMS
    "SeanceEmsBase",
    "SeanceEmsCreate",
    "SeanceEmsUpdate",
    "SeanceEmsRead",

    # Seance Exercice
    "SeanceExerciceBase",
    "SeanceExerciceCreate",
    "SeanceExerciceUpdate",
    "SeanceExerciceRead",

    # Repetition
    "RepetitionBase",
    "RepetitionCreate",
    "RepetitionUpdate",
    "RepetitionRead",

    # Analyse Posturale
    "AnalysePosturaleBase",
    "AnalysePosturaleCreate",
    "AnalysePosturaleUpdate",
    "AnalysePosturaleRead",

    # Mesure Biomécanique
    "MesureBiomecaniqueBase",
    "MesureBiomecaniqueCreate",
    "MesureBiomecaniqueUpdate",
    "MesureBiomecaniqueRead",

    # Type Erreur Posturale
    "TypeErreurPosturaleBase",
    "TypeErreurPosturaleCreate",
    "TypeErreurPosturaleUpdate",
    "TypeErreurPosturaleRead",

    # Erreur Posturale
    "ErreurPosturaleBase",
    "ErreurPosturaleCreate",
    "ErreurPosturaleUpdate",
    "ErreurPosturaleRead",
]