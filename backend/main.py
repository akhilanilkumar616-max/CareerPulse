import logging
import os
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from api.routes.health import router as health_router
from api.routes.analysis import router as analysis_router
from api.routes.history import router as history_router
from api.routes.profile import router as profile_router
from database import init_db
from services.skill_matcher import SkillMatcher

# Load environment configuration
load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("careerpulse-backend")


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: Initialize Database Tables
    logger.info("Initializing PostgreSQL / SQLite database tables...")
    try:
        init_db()
    except Exception as dbe:
        logger.error(f"Database table initialization warning: {dbe}")

    # Startup: Preload Sentence Transformer model into memory
    logger.info("Starting CareerPulse AI Analysis Engine...")
    try:
        SkillMatcher.get_model()
    except Exception as e:
        logger.warning(f"Model preloading deferred: {e}")
        
    yield
    # Shutdown
    logger.info("Shutting down CareerPulse AI Analysis Engine.")


app = FastAPI(
    title="CareerPulse AI Resume Analysis Backend",
    description="NLP-powered resume parsing, semantic skill gap analysis, and employability assessment engine.",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS configuration allowing cross-origin requests from Flutter Web, Android Emulators, and Desktop clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register API routes with prefix /api/v1
app.include_router(health_router, prefix="/api/v1")
app.include_router(analysis_router, prefix="/api/v1")
app.include_router(history_router, prefix="/api/v1")
app.include_router(profile_router, prefix="/api/v1")


if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", "8000"))
    host = os.getenv("HOST", "0.0.0.0")
    uvicorn.run("main:app", host=host, port=port, reload=True)
