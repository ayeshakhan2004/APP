"""CIRO Backend — FastAPI Entry Point"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

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


@app.get("/health")
async def health():
    return {"status": "ok", "service": "ciro-backend"}


# TODO: Include routers
# from .routes import signals, crises, resources, simulation, traces
# app.include_router(signals.router, prefix="/api/signals", tags=["signals"])
# app.include_router(crises.router, prefix="/api/crises", tags=["crises"])
# app.include_router(resources.router, prefix="/api/resources", tags=["resources"])
# app.include_router(simulation.router, prefix="/api/simulation", tags=["simulation"])
# app.include_router(traces.router, prefix="/api/traces", tags=["traces"])
