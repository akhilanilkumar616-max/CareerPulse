import logging
import os
import threading
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from api.routes.health import router as health_router
from api.routes.analysis import router as analysis_router
from api.routes.history import router as history_router
from api.routes.profile import router as profile_router
from database import init_db

# Load environment configuration
load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger("careerpulse-backend")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Non-blocking lifespan manager.
    Ensures instantaneous startup so Uvicorn binds to $PORT immediately on Render.
    Heavy AI models are loaded lazily on the first incoming analysis request.
    Database schema is verified in a background daemon thread without blocking.
    """
    logger.info("CareerPulse Backend starting up...")

    # Non-blocking background database schema verification
    threading.Thread(target=init_db, daemon=True, name="db-init-worker").start()

    logger.info("AI models configured for lazy loading on demand.")
    logger.info("FastAPI ready to bind port immediately.")

    yield

    # Shutdown
    logger.info("Shutting down CareerPulse Backend.")



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
