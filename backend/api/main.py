"""CIRO Backend — FastAPI Entry Point"""

import sys
import os

# Add the backend/ directory to the path so that 'agents', 'utils', 'services'
# are all importable regardless of which directory uvicorn is launched from.
sys.path.insert(0, os.path.dirname(__file__) + "/..")

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.routes import router

app = FastAPI(
    title="CIRO API",
    description="Crisis Intelligence & Response Orchestrator",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router, prefix="/api")


@app.get("/health")
async def health():
    return {"status": "ok", "service": "ciro-backend"}
