# iMotion Posture

**iMotion Posture** est une application web destinée au suivi des séances d’EMS et à l’accompagnement du coach dans l’analyse des mouvements réalisés par les adhérents.

L’application combine une interface de gestion, une analyse posturale en temps réel et un module d’intelligence artificielle permettant d’évaluer l’exécution des exercices et de suivre les performances au cours des séances.

## Fonctionnalités

* Authentification sécurisée des coachs
* Gestion des adhérents
* Gestion et suivi des séances EMS
* Analyse posturale en temps réel
* Détection et comptage des répétitions
* Évaluation de la posture
* Détection des erreurs posturales
* Calcul d’un score de performance
* Consultation de l’historique des séances
* Visualisation des statistiques et résultats

## Architecture

Le projet est organisé autour de trois composants principaux :

```text
iMotion Posture
│
├── backend/
│   ├── app/
│   │   ├── api/
│   │   ├── crud/
│   │   ├── database/
│   │   ├── ia/
│   │   ├── models/
│   │   ├── routers/
│   │   └── services/
│   └── tests/
│
└── flutter_app/
    └── lib/
        ├── core/
        ├── features/
        ├── models/
        ├── providers/
        └── services/
```

### Backend

Le backend est développé avec **FastAPI** et assure la gestion des utilisateurs, des adhérents, des séances ainsi que la communication avec le module d’analyse posturale.

### Application frontend

L’interface est développée avec **Flutter Web**. Elle permet au coach de gérer les adhérents, démarrer une séance, suivre l’analyse en direct et consulter les résultats enregistrés.

### Intelligence artificielle

Le module d’analyse repose sur :

* **OpenCV** pour le traitement des images ;
* **MediaPipe Pose** pour l’extraction des points clés du corps ;
* **Feature Engineering** pour calculer les caractéristiques posturales ;
* **Random Forest** pour classifier la posture ;
* un système de règles pour l’interprétation des erreurs ;
* un mécanisme de comptage des répétitions.

L’analyse en temps réel est assurée par une communication **WebSocket** entre l’application Flutter et le backend.

## Technologies

| Domaine                  | Technologies                |
| ------------------------ | --------------------------- |
| Frontend                 | Flutter, Dart               |
| Backend                  | Python, FastAPI             |
| Base de données          | MySQL                       |
| ORM                      | SQLAlchemy                  |
| IA / Machine Learning    | scikit-learn, Random Forest |
| Computer Vision          | OpenCV, MediaPipe Pose      |
| Communication temps réel | WebSocket                   |
| Authentification         | JWT                         |

## Installation

### Backend

```bash
cd backend
python -m venv .venv
```

Activation de l’environnement virtuel sous Windows :

```bash
.venv\Scripts\activate
```

Installation des dépendances :

```bash
pip install -r requirements.txt
```

Lancement du serveur :

```bash
uvicorn app.main:app --reload
```

Le backend est alors accessible à :

```text
http://127.0.0.1:8000
```

### Frontend

```bash
cd flutter_app
flutter pub get
flutter run -d chrome
```

## Base de données

L’application utilise une base de données **MySQL** pour stocker notamment les informations relatives aux coachs, aux adhérents et aux séances.

La configuration de la connexion à la base de données doit être définie dans l’environnement local avant le lancement du backend.

## Tests

Le projet contient des tests couvrant notamment :

* la configuration ;
* la connexion à la base de données ;
* les opérations CRUD ;
* la sécurité et l’authentification ;
* le fonctionnement du module d’analyse posturale.

## Statut du projet

**Projet réalisé dans le cadre d’un stage d’été.**

L’objectif est de fournir un outil permettant au coach de centraliser la gestion des adhérents et des séances tout en bénéficiant d’une analyse automatisée de la posture pendant les exercices.
