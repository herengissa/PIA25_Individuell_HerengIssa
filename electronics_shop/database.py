# Databasanslutning med SQLAlchemy

import os
from sqlalchemy import create_engine
from sqlalchemy.exc import OperationalError
from sqlalchemy.orm import sessionmaker, Session
from .models import Base


def _get_database_url():
    """Hämtar databas-URL från miljövariabler."""
    dbname = os.getenv("POSTGRES_DB", "electronics_db")
    user = os.getenv("POSTGRES_USER", "postgres")
    password = os.getenv("POSTGRES_PASSWORD", "postgres")
    host = os.getenv("POSTGRES_HOST", "localhost")
    port = int(os.getenv("POSTGRES_PORT", "5432"))
    return f"postgresql://{user}:{password}@{host}:{port}/{dbname}"


_engine = None
_SessionLocal = None


def get_engine():
    """Skapar eller returnerar SQLAlchemy engine."""
    global _engine
    if _engine is None:
        database_url = _get_database_url()
        _engine = create_engine(database_url, echo=False, pool_pre_ping=True)
    return _engine


def get_session() -> Session:
    """Skapar en ny databas-session."""
    global _SessionLocal
    if _SessionLocal is None:
        engine = get_engine()
        _SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

    try:
        return _SessionLocal()
    except OperationalError as exc:
        raise OperationalError(
            f"Kunde inte ansluta till PostgreSQL: {exc}", params=None, orig=exc
        ) from exc


def init_db():
    """Skapar alla tabeller i databasen."""
    engine = get_engine()
    Base.metadata.create_all(bind=engine)
