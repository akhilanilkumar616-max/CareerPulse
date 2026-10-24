import logging
import os
from typing import Generator
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker, Session

logger = logging.getLogger("careerpulse-db")

# Read database URL from environment
raw_db_url = os.getenv("DATABASE_URL", "").strip()

if raw_db_url:
    # Render and Heroku use 'postgres://', but SQLAlchemy 2.0 requires 'postgresql://'
    if raw_db_url.startswith("postgres://"):
        DATABASE_URL = raw_db_url.replace("postgres://", "postgresql://", 1)
    else:
        DATABASE_URL = raw_db_url
    
    # PostgreSQL engine with pre-ping to handle recycled connections
    engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True,
        pool_size=10,
        max_overflow=20,
    )
    logger.info("Configured PostgreSQL connection pool.")
else:
    # Fallback to local SQLite for local dev & testing if no PostgreSQL provided
    DATABASE_URL = "sqlite:///./careerpulse.db"
    engine = create_engine(
        DATABASE_URL,
        connect_args={"check_same_thread": False},
    )
    logger.info("DATABASE_URL not set; using local SQLite fallback (careerpulse.db).")

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db() -> Generator[Session, None, None]:
    """FastAPI dependency that provides a transactional database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def init_db() -> None:
    """Create all database tables if they do not exist."""
    try:
        import models.db_models  # Ensure models are registered with Base.metadata
        Base.metadata.create_all(bind=engine)
        logger.info("Database schema verified and tables initialized successfully.")
    except Exception as e:
        logger.error(f"Failed to initialize database tables: {e}", exc_info=True)
