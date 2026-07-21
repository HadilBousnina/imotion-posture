from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routers import erreur_posturale
from app.routers import type_erreur_posturale
from app.routers import mesure_biomecanique
from app.routers import repetition
from app.routers import seance_exercice
from app.routers import seance_ems
from app.routers import coach
from app.routers import auth
from app.routers import adherent
from app.routers import exercice
import app.routers.analyse_posturale as analyse_posturale
app = FastAPI(
    title="iMotion Posture API",
    version="1.0.0",
    description="Backend API pour l'application iMotion Posture",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # À restreindre en production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routes

@app.get("/")
def root():
    return {
        "message": "Bienvenue sur l'API iMotion Posture 🚀"
    }


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