"""API routes for CIRO backend."""

from fastapi import APIRouter, HTTPException
from typing import Dict, Any
import json
import os

router = APIRouter()

from supabase import create_client
from dotenv import load_dotenv

load_dotenv()
url = os.getenv("SUPABASE_URL")

supabase_url = os.getenv("SUPABASE_URL")
supabase_key = os.getenv("SUPABASE_KEY")
supabase = create_client(supabase_url, supabase_key)

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
    # Fetch the real resources you just seeded into Supabase!
    db_resources = supabase.table('resources').select("*").eq("status", "available").execute()
        
    # Use the database resources. If it fails for any reason, fallback to the mock data.
    resources = db_resources.data if hasattr(db_resources, 'data') and db_resources.data else load_mock('resources_inventory.json')

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
    """Export all Supabase traces to a JSON file."""
    try:
        scenario = data.get("scenario", "default")
        response = supabase.table('traces').select("*").execute()
        db_traces = response.data or []

        traces_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'traces')
        os.makedirs(traces_dir, exist_ok=True)
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join(traces_dir, f"{scenario}_{timestamp}.json")
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(db_traces, f, indent=2, default=str)

        return {"exported_to": path, "trace_count": len(db_traces)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to export traces: {str(e)}")


@router.get("/crises")
async def get_crises():
    """Get all crises from Supabase."""
    try:
        response = supabase.table('crises').select("*").execute()
        return {"crises": response.data, "count": len(response.data)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch crises: {str(e)}")


@router.get("/notifications")
async def get_notifications():
    """Get all stakeholder notifications from Supabase."""
    try:
        response = supabase.table('notifications').select("*").execute()
        return {"notifications": response.data, "count": len(response.data)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch notifications: {str(e)}")


@router.get("/allocations")
async def get_allocations():
    """Get all resource allocations from Supabase."""
    try:
        response = supabase.table('allocations').select("*").execute()
        return {"allocations": response.data, "count": len(response.data)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch allocations: {str(e)}")


@router.post("/crises/export")
async def export_crises(data: Dict[str, Any] = {"scenario": "default"}):
    """Export all Supabase crises to a JSON file."""
    try:
        scenario = data.get("scenario", "default")
        response = supabase.table('crises').select("*").execute()
        db_crises = response.data or []

        export_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'exports')
        os.makedirs(export_dir, exist_ok=True)
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join(export_dir, f"crises_{scenario}_{timestamp}.json")
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(db_crises, f, indent=2, default=str)

        return {"exported_to": path, "crisis_count": len(db_crises)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to export crises: {str(e)}")


@router.post("/notifications/export")
async def export_notifications(data: Dict[str, Any] = {"scenario": "default"}):
    """Export all Supabase notifications to a JSON file."""
    try:
        scenario = data.get("scenario", "default")
        response = supabase.table('notifications').select("*").execute()
        db_notifications = response.data or []

        export_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'exports')
        os.makedirs(export_dir, exist_ok=True)
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join(export_dir, f"notifications_{scenario}_{timestamp}.json")
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(db_notifications, f, indent=2, default=str)

        return {"exported_to": path, "notification_count": len(db_notifications)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to export notifications: {str(e)}")


@router.post("/allocations/export")
async def export_allocations(data: Dict[str, Any] = {"scenario": "default"}):
    """Export all Supabase allocations to a JSON file."""
    try:
        scenario = data.get("scenario", "default")
        response = supabase.table('allocations').select("*").execute()
        db_allocations = response.data or []

        export_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'docs', 'exports')
        os.makedirs(export_dir, exist_ok=True)
        from datetime import datetime
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        path = os.path.join(export_dir, f"allocations_{scenario}_{timestamp}.json")
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(db_allocations, f, indent=2, default=str)

        return {"exported_to": path, "allocation_count": len(db_allocations)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to export allocations: {str(e)}")
