"""
Script de test : vérifie que SQLAlchemy arrive à se connecter à ta vraie base MySQL
et que les 10 tables existent bien.

Usage :
    python test_connection.py
"""

import sys

from dotenv import load_dotenv

load_dotenv()  # charge le fichier .env avant d'importer la config DB

from sqlalchemy import inspect
from sqlalchemy.exc import OperationalError

from app.database.database import engine
from app.database import models  # noqa: F401 - importe tous les modèles


def test_connection():
    print("Tentative de connexion à :", engine.url)
    try:
        with engine.connect() as conn:
            print("✅ Connexion réussie à MySQL !\n")
    except OperationalError as e:
        print("❌ Échec de connexion à MySQL.")
        print("Détail de l'erreur :", e)
        sys.exit(1)

    inspector = inspect(engine)
    tables_reelles = set(inspector.get_table_names())

    tables_attendues = {
        "coachs",
        "adherents",
        "exercices",
        "seances_ems",
        "seances_exercices",
        "repetitions",
        "analyses_posturales",
        "mesures_biomecaniques",
        "erreurs_posturales",
        "types_erreurs_posturales",
    }

    print("Tables trouvées dans la base :")
    for t in sorted(tables_reelles):
        print(" -", t)

    manquantes = tables_attendues - tables_reelles
    if manquantes:
        print("\n⚠️  Tables attendues mais absentes de la base :", manquantes)
    else:
        print("\n✅ Les 10 tables attendues sont bien présentes dans MySQL.")


if __name__ == "__main__":
    test_connection()