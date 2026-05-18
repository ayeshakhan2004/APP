"""API routes for CIRO backend."""

from fastapi import APIRouter, HTTPException
from typing import Dict, Any
import json
import os

router = APIRouter()

MOCK_DIR = os.path.join(os.path.dirname(__file__), '..', 'mock_data')


def load_mock(filename: str):
    path = os.path.join(MOCK_DIR, filename)
    with open(path) as f:
        return json.load(f)


@router.get("/signals")
async def get_signals():
    """Get all signals from all sources."""
    signals = []
    for fname in ['social_media_signals.json', 'weather_signals.json', 'traffic_signals.json', 'emergency_calls.json', 'iot_sensors.json']:
        signals.extend(load_mock(fname))
    return {"signals": signals, "count": len(signals)}


@router.get("/resources")
async def get_resources():
    """Get all available resources."""
    resources = load_mock('resources_inventory.json')
    return {"resources": resources, "count": len(resources)}


@router.post("/pipeline/run")
async def run_full_pipeline():
    """Run the complete CIRO crisis detection pipeline."""
    from agents.orchestrator import CIROOrchestrator

    # Load all signals
    signals = []
    for fname in ['social_media_signals.json', 'weather_signals.json', 'traffic_signals.json', 'emergency_calls.json', 'iot_sensors.json']:
        signals.extend(load_mock(fname))

    resources = load_mock('resources_inventory.json')

    orchestrator = CIROOrchestrator()
    result = await orchestrator.run_pipeline(signals, resources)
    return result


@router.post("/pipeline/recover")
async def run_recovery(data: Dict[str, Any]):
    """Run recovery flow for false alarm or reclassification."""
    from agents.orchestrator import CIROOrchestrator

    crisis_id = data.get("crisis_id", "")
    original_crisis = data.get("original_crisis", {})
    verification_data = data.get("verification_data", {})

    if not crisis_id:
        raise HTTPException(status_code=400, detail="crisis_id is required")

    orchestrator = CIROOrchestrator()
    result = await orchestrator.run_recovery(crisis_id, {
        "original_crisis": original_crisis,
        "verification_data": verification_data,
    })
    return result


@router.get("/traces")
async def get_traces():
    """Get all captured traces."""
    from utils.trace_logger import trace_logger
    return {"traces": [t.model_dump(mode="json") for t in trace_logger.traces], "count": len(trace_logger.traces)}


@router.post("/traces/export")
async def export_traces(data: Dict[str, Any] = {"scenario": "default"}):
    """Export traces to JSON file."""
    from utils.trace_logger import trace_logger
    scenario = data.get("scenario", "default")
    path = trace_logger.export_traces(scenario)
    return {"exported_to": path, "trace_count": len(trace_logger.traces)}
