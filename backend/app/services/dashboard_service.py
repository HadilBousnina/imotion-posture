from datetime import datetime, timedelta

from sqlalchemy.orm import Session
from sqlalchemy import func

from app.database.models.adherent import Adherent
from app.database.models.seance_ems import SeanceEms


def get_dashboard_stats(db: Session, id_coach: int):
    # =====================================================
    # NOMBRE TOTAL D'ADHÉRENTS
    # =====================================================

    total_adherents = (
        db.query(func.count(Adherent.id_adherent))
        .filter(
            Adherent.id_coach == id_coach
        )
        .scalar()
        or 0
    )

    # =====================================================
    # DATES
    # =====================================================

    now = datetime.now()

    start_today = datetime(
        now.year,
        now.month,
        now.day,
    )

    end_today = start_today + timedelta(days=1)

    # =====================================================
    # SÉANCES AUJOURD'HUI
    # =====================================================

    sessions_today = (
        db.query(func.count(SeanceEms.id_seance))
        .filter(
            SeanceEms.id_coach == id_coach,
            SeanceEms.date_debut >= start_today,
            SeanceEms.date_debut < end_today,
        )
        .scalar()
        or 0
    )

    # =====================================================
    # SCORE MOYEN GLOBAL
    # =====================================================

    average_score = (
        db.query(func.avg(SeanceEms.score_global))
        .filter(
            SeanceEms.id_coach == id_coach,
            SeanceEms.score_global.isnot(None),
        )
        .scalar()
    )

    average_score = (
        round(float(average_score), 1)
        if average_score is not None
        else 0
    )

    # =====================================================
    # PROGRESSION CE MOIS
    # =====================================================

    start_month = datetime(
        now.year,
        now.month,
        1,
    )

    # Premier jour du mois suivant
    if now.month == 12:
        start_next_month = datetime(
            now.year + 1,
            1,
            1,
        )
    else:
        start_next_month = datetime(
            now.year,
            now.month + 1,
            1,
        )

    sessions_month = (
        db.query(SeanceEms)
        .filter(
            SeanceEms.id_coach == id_coach,
            SeanceEms.date_debut >= start_month,
            SeanceEms.date_debut < start_next_month,
            SeanceEms.score_global.isnot(None),
        )
        .order_by(SeanceEms.date_debut.asc())
        .all()
    )

    progression = 0

    if len(sessions_month) >= 2:

        first_score = sessions_month[0].score_global
        last_score = sessions_month[-1].score_global

        if first_score is not None and first_score != 0:
            progression = round(
                (
                    (last_score - first_score)
                    / first_score
                ) * 100
            )

    return {
        "total_adherents": total_adherents,
        "sessions_today": sessions_today,
        "average_score": average_score,
        "progression": progression,
    }