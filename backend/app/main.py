from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import (
    auth,
    coach,
    adherent,
    exercice,
    analyse_posturale,
    seance_ems,
    seance_exercice,
    repetition,
    mesure_biomecanique,
    type_erreur_posturale,
    erreur_posturale,
    posture,
    websocket,
    dashboard,
)

app = FastAPI(
    title="iMotion Posture API",
    version="1.0.0",
    description="Backend API pour l'application iMotion Posture",
)

# =========================================================
# CORS
# =========================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# =========================================================
# ROUTE RACINE
# =========================================================

@app.get("/")
def root():
    return {
        "message": "Bienvenue sur l'API iMotion Posture 🚀"
    }

# =========================================================
# ROUTES
# =========================================================

app.include_router(auth.router)
app.include_router(coach.router)
app.include_router(adherent.router)
app.include_router(exercice.router)

app.include_router(analyse_posturale.router)

app.include_router(seance_ems.router)
app.include_router(seance_exercice.router)

app.include_router(repetition.router)
app.include_router(mesure_biomecanique.router)
app.include_router(type_erreur_posturale.router)
app.include_router(erreur_posturale.router)

app.include_router(posture.router)
app.include_router(websocket.router)

app.include_router(dashboard.router)
