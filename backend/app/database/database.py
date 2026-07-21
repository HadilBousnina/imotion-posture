import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

load_dotenv()  # charge le .env quel que soit le script qui importe ce module

# Exemple d'URL : mysql+pymysql://user:password@host:3306/imotion_db
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "mysql+pymysql://imotion_user:imotion_pass@db:3306/imotion_db",
)

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # évite les connexions MySQL "mortes" (timeout)
    pool_recycle=3600,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()


def get_db():
    """Dependency FastAPI : ouvre une session DB, la ferme après la requête."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()