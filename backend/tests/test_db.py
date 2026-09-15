"""
Script de test CRUD : valide que la couche ORM fonctionne complètement
(SELECT, INSERT, UPDATE, DELETE) sur une table simple (Coach) avant de
passer aux schémas Pydantic.

Usage :
    python test_db.py
"""

from dotenv import load_dotenv

load_dotenv()

from app.database.database import SessionLocal
from app.database.models.coach import Coach


def test_read():
    print("\n--- TEST READ (SELECT) ---")
    db = SessionLocal()
    try:
        coaches = db.query(Coach).all()
        print(f"Nombre de coachs existants : {len(coaches)}")
        for c in coaches:
            print(f"  - id={c.id_coach} | {c.prenom} {c.nom} | {c.email}")
    finally:
        db.close()


def test_create():
    print("\n--- TEST CREATE (INSERT) ---")
    db = SessionLocal()
    try:
        nouveau_coach = Coach(
            nom="Test",
            prenom="Script",
            email="test.script@imotion.local",
            password_hash="fake_hash_pour_test",
        )
        db.add(nouveau_coach)
        db.commit()
        db.refresh(nouveau_coach)
        print(f"✅ Coach créé avec id_coach = {nouveau_coach.id_coach}")
        return nouveau_coach.id_coach
    finally:
        db.close()


def test_update(id_coach: int):
    print("\n--- TEST UPDATE ---")
    db = SessionLocal()
    try:
        coach = db.query(Coach).filter(Coach.id_coach == id_coach).first()
        if not coach:
            print("❌ Coach introuvable, update annulé.")
            return
        coach.prenom = "ScriptModifie"
        db.commit()
        db.refresh(coach)
        print(f"✅ Coach {id_coach} mis à jour : prenom = {coach.prenom}")
    finally:
        db.close()


def test_delete(id_coach: int):
    print("\n--- TEST DELETE ---")
    db = SessionLocal()
    try:
        coach = db.query(Coach).filter(Coach.id_coach == id_coach).first()
        if not coach:
            print("❌ Coach introuvable, delete annulé.")
            return
        db.delete(coach)
        db.commit()
        print(f"✅ Coach {id_coach} supprimé.")
    finally:
        db.close()


if __name__ == "__main__":
    test_read()
    new_id = test_create()
    test_update(new_id)
    test_read()  # pour voir la modification
    test_delete(new_id)
    test_read()  # pour confirmer la suppression