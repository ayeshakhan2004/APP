"""CIRO Orchestrator — Main pipeline that chains all agents via Antigravity."""

import uuid
import asyncio
from typing import Any, Dict, List
from agents.signal_fusion.agent import SignalFusionAgent
from agents.crisis_detector.agent import CrisisDetectorAgent
from agents.severity_predictor.agent import SeverityPredictorAgent
from agents.resource_allocator.agent import ResourceAllocatorAgent
from agents.action_simulator.agent import ActionSimulatorAgent
from agents.stakeholder_notifier.agent import StakeholderNotifierAgent
from agents.recovery.agent import RecoveryAgent
from utils.trace_logger import trace_logger
from services.supabase_client import supabase


class CIROOrchestrator:
    """
    Main orchestrator — this is what Antigravity coordinates.
    Pipeline: Ingest → Fuse → Detect → Predict → Allocate → Simulate → Notify
    Recovery runs on-demand when verification data arrives.
    """

    def __init__(self):
        self.signal_fusion = SignalFusionAgent()
        self.crisis_detector = CrisisDetectorAgent()
        self.severity_predictor = SeverityPredictorAgent()
        self.resource_allocator = ResourceAllocatorAgent()
        self.action_simulator = ActionSimulatorAgent()
        self.stakeholder_notifier = StakeholderNotifierAgent()
        self.recovery = RecoveryAgent()

    async def run_pipeline(self, raw_signals: List[Dict[str, Any]], available_resources: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Execute the full crisis response pipeline."""
        try:
            db_signals = supabase.table('signals').select("*").order("created_at", desc=True).limit(5).execute()
            if hasattr(db_signals, "data") and db_signals.data:
                # Merge DB signals with Swagger signals
                raw_signals.extend(db_signals.data)
        except Exception as e:
            print(f"❌ DB ERROR: Failed to fetch signals from Supabase: {e}")
            
        print(f"🚨 DEBUG: Pipeline starting with {len(raw_signals)} total signals!")  
        trace_logger.log_reasoning("orchestrator", "Starting CIRO pipeline with {} signals and {} resources".format(
            len(raw_signals), len(available_resources)
        ), {"phase": "pipeline_start"})

# Step 1: Signal Fusion
        fused = await self.signal_fusion.run({"signals": raw_signals})
        print("\n🚨🚨🚨 RAW FUSED OUTPUT:", type(fused), fused, "\n", flush=True)

        # Step 2: Crisis Detection
        detected = await self.crisis_detector.run({"fused_signals": fused.get("fused_signals", [])})
        print("\n🚨🚨🚨 RAW DETECTED OUTPUT:", type(detected), detected, "\n", flush=True)
        
        # --- SUPABASE HOOK: Save Crises ---
        crises_list = detected.get("crises_detected", [])
        for crisis in crises_list:
            try:
                # Map strictly to prevent Supabase "unknown column" errors
                # Must match crises table: type, location, severity, confidence_score, affected_population
                crisis_type = crisis.get("type", "flood")
                if crisis_type not in ('flood','heatwave','accident','infrastructure','power_outage','protest','disease'):
                    crisis_type = 'infrastructure'  # Default fallback if LLM invents a type
                
                severity = crisis.get("severity", "moderate")
                if severity not in ('critical','high','moderate','low'):
                    severity = 'moderate'

                crisis_payload = {
                    "type": crisis_type,
                    "location": crisis.get("location", {"lat": 24.8607, "lng": 67.0011, "area_name": "Karachi"}),
                    "severity": severity,
                    "confidence_score": crisis.get("confidence_score", 0.5),
                    "affected_population": crisis.get("affected_population_estimate", 0)
                }
                supabase.table('crises').insert(crisis_payload).execute()
                print(f"✅ DB SUCCESS: Inserted crisis {crisis_payload['type']}")
            except Exception as e:
                print(f"❌ DB ERROR: Crisis insert failed: {e}")
                trace_logger.log_reasoning("orchestrator", f"Supabase crisis insert failed: {e}", {"phase": "supabase_error"})

        # Step 3: Severity Prediction
        predicted = await self.severity_predictor.run({"crises_detected": crises_list})

        # Step 4: Resource Allocation
        allocated = await self.resource_allocator.run({
            "crises_with_predictions": predicted.get("predictions", []),
            "available_resources": available_resources,
        })

        # --- SUPABASE HOOK: Update Resource Status ---
        allocations_list = allocated.get("allocations", [])
        for allocation in allocations_list:
            assigned_resources = allocation.get("assigned_resources", [])
            for res in assigned_resources:
                resource_id = res.get("resource_id")
                if resource_id:
                    try:
                        # Ignore LLM-generated fake string IDs, Supabase requires valid UUIDs
                        # If resource_id is not a valid UUID format, this will fail but it's safely caught
                        if len(str(resource_id)) > 10:  
                            supabase.table('resources').update({"status": "deployed"}).eq("id", resource_id).execute()
                            print(f"✅ DB SUCCESS: Deployed resource {resource_id}")
                    except Exception as e:
                        print(f"❌ DB ERROR: Resource update failed for {resource_id}: {e}")
                        trace_logger.log_reasoning("orchestrator", f"Supabase resource update failed: {e}", {"phase": "supabase_error"})

        # Step 5: Action Simulation
        simulated = await self.action_simulator.run({"allocations": allocations_list})

        # Step 6: Stakeholder Notification
        notifications = {}
        for crisis in crises_list:
            notif = await self.stakeholder_notifier.run({
                "crisis": crisis,
                "simulation": simulated,
            })
            # Handle potential missing ID gracefully
            crisis_id = crisis.get("id") or crisis.get("cluster_id") or "unknown"
            notifications[crisis_id] = notif

        trace_logger.log_reasoning("orchestrator", "Pipeline complete", {"phase": "pipeline_end"})

        return {
            "fused_signals": fused,
            "crises_detected": detected,
            "predictions": predicted,
            "allocations": allocated,
            "simulations": simulated,
            "notifications": notifications,
        }

    async def run_recovery(self, crisis_id: str, verification_data: Dict[str, Any]) -> Dict[str, Any]:
        """Run recovery flow for false alarm or reclassification."""
        return await self.recovery.run({
            "crisis_id": crisis_id,
            "verification_data": verification_data,
        })
    # --- Add this at the very bottom of orchestrator.py ---
if __name__ == "__main__":
    async def test():
        print("🚀 Booting up CIRO Orchestrator...")
        orchestrator = CIROOrchestrator()
        
        # Passing empty lists just to test if the pipeline starts
        result = await orchestrator.run_pipeline([], [])
        print("✅ Pipeline finished successfully!")

    # This tells Python to actually run the code above
    asyncio.run(test())