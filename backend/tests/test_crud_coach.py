from app.database.database import SessionLocal
from app.crud.coach import (
    get_coachs,
    get_coach,
    create_coach,
    update_coach,
    delete_coach,
)
from app.database.schemas.coach import (
    CoachCreate,
    CoachUpdate,
)


db = SessionLocal()


try:

    print("\n--- TEST READ ALL ---")
    coachs = get_coachs(db)
    print(f"Nombre de coachs : {len(coachs)}")


    print("\n--- TEST CREATE ---")

    new_coach = CoachCreate(
        nom="CRUD",
        prenom="Test",
        email="crud.test@imotion.com",
        password="123456"
    )

    coach = create_coach(db, new_coach)

    print(
        f"✅ Coach créé : id={coach.id_coach}, "
        f"{coach.nom} {coach.prenom}"
    )


    print("\n--- TEST READ ONE ---")

    coach_found = get_coach(
        db,
        coach.id_coach
    )

    print(
        f"✅ Trouvé : {coach_found.email}"
    )


    print("\n--- TEST UPDATE ---")

    update = CoachUpdate(
        prenom="Modifie"
    )

    updated = update_coach(
        db,
        coach.id_coach,
        update
    )

    print(
        f"✅ Nouveau prénom : {updated.prenom}"
    )


    print("\n--- TEST DELETE ---")

    deleted = delete_coach(
        db,
        coach.id_coach
    )

    print(
        f"✅ Supprimé : id={deleted.id_coach}"
    )


finally:
    db.close()