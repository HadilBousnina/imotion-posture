from app.crud.coach import (
    get_coachs,
    get_coach,
    create_coach,
    update_coach,
    delete_coach,
)

from app.crud.adherent import (
    get_adherents,
    get_adherent,
    create_adherent,
    update_adherent,
    delete_adherent,
)

from app.crud.exercice import (
    get_exercices,
    get_exercice,
    create_exercice,
    update_exercice,
    delete_exercice,
)

from app.crud.seance_ems import (
    get_seances_ems,
    get_seance_ems,
    create_seance_ems,
    update_seance_ems,
    delete_seance_ems,
)

from app.crud.seance_exercice import (
    get_seances_exercices,
    get_seance_exercice,
    create_seance_exercice,
    update_seance_exercice,
    delete_seance_exercice,
)

from app.crud.repetition import (
    get_repetitions,
    get_repetition,
    create_repetition,
    update_repetition,
    delete_repetition,
)

from app.crud.analyse_posturale import (
    get_analyses_posturales,
    get_analyse_posturale,
    create_analyse_posturale,
    update_analyse_posturale,
    delete_analyse_posturale,
)

from app.crud.mesure_biomecanique import (
    get_mesures_biomecaniques,
    get_mesure_biomecanique,
    create_mesure_biomecanique,
    update_mesure_biomecanique,
    delete_mesure_biomecanique,
)

from app.crud.type_erreur_posturale import (
    get_types_erreurs_posturales,
    get_type_erreur_posturale,
    create_type_erreur_posturale,
    update_type_erreur_posturale,
    delete_type_erreur_posturale,
)

from app.crud.erreur_posturale import (
    get_erreurs_posturales,
    get_erreur_posturale,
    create_erreur_posturale,
    update_erreur_posturale,
    delete_erreur_posturale,
)


__all__ = [
    # Coach
    "get_coachs",
    "get_coach",
    "create_coach",
    "update_coach",
    "delete_coach",

    # Adherent
    "get_adherents",
    "get_adherent",
    "create_adherent",
    "update_adherent",
    "delete_adherent",

    # Exercice
    "get_exercices",
    "get_exercice",
    "create_exercice",
    "update_exercice",
    "delete_exercice",

    # Seance EMS
    "get_seances_ems",
    "get_seance_ems",
    "create_seance_ems",
    "update_seance_ems",
    "delete_seance_ems",

    # Seance Exercice
    "get_seances_exercices",
    "get_seance_exercice",
    "create_seance_exercice",
    "update_seance_exercice",
    "delete_seance_exercice",

    # Repetition
    "get_repetitions",
    "get_repetition",
    "create_repetition",
    "update_repetition",
    "delete_repetition",

    # Analyse Posturale
    "get_analyses_posturales",
    "get_analyse_posturale",
    "create_analyse_posturale",
    "update_analyse_posturale",
    "delete_analyse_posturale",

    # Mesure Biomécanique
    "get_mesures_biomecaniques",
    "get_mesure_biomecanique",
    "create_mesure_biomecanique",
    "update_mesure_biomecanique",
    "delete_mesure_biomecanique",

    # Type Erreur Posturale
    "get_types_erreurs_posturales",
    "get_type_erreur_posturale",
    "create_type_erreur_posturale",
    "update_type_erreur_posturale",
    "delete_type_erreur_posturale",

    # Erreur Posturale
    "get_erreurs_posturales",
    "get_erreur_posturale",
    "create_erreur_posturale",
    "update_erreur_posturale",
    "delete_erreur_posturale",
]