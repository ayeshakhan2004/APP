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
            print("🔍 Fetching live signals from Supabase...")
            db_signals = supabase.table('signals').select("*").order("created_at", desc=True).limit(5).execute()
            if hasattr(db_signals, "data") and db_signals.data:
                raw_signals.extend(db_signals.data)
        except Exception as e:
            print(f"❌ DB ERROR: Failed to fetch signals from Supabase: {e}")
            
        print(f"🚨 DEBUG: Pipeline starting with {len(raw_signals)} total signals!")  
        trace_logger.log_reasoning("orchestrator", "Starting CIRO pipeline with {} signals and {} resources".format(
            len(raw_signals), len(available_resources)
        ), {"phase": "pipeline_start"})

# Step 1: Signal Fusion
        fused = await self.signal_fusion.run({"signals": raw_signals})
        print("\n🚨🚨🚨 RAW FUSED OUTPUT:", type(fused), fused, "\n")

        # Step 2: Crisis Detection
        detected = await self.crisis_detector.run({"fused_signals": fused.get("fused_signals", [])})
        print("\n🚨🚨🚨 RAW DETECTED OUTPUT:", type(detected), detected, "\n")
        
        # --- SUPABASE HOOK: Save Crises ---
        crises_list = detected.get("crises_detected", [])
        for crisis in crises_list:
            try:
                # Map strictly to prevent Supabase "unknown column" errors
                # Must match crises table: type, location, severity, confidence_score, affected_population
                crisis_type = crisis.get("type", "flood")
                if crisis_type not in ('flood','heatwave','accident','infrastructure','power_outage','protest','disease'):
                    crisis_type = 'infrastructure'  # Default fallback if LLM invents a type

        # Step 1: Signal Fusion
        print("\n🧠 AI Step 1: Fusing Signals...")
        fused = await self.signal_fusion.run({"signals": raw_signals})
        print(f"🚨 RAW FUSED OUTPUT: {fused}")

        # Step 2: Crisis Detection
        print("\n🧠 AI Step 2: Detecting Crises...")
        detected = await self.crisis_detector.run({"fused_signals": fused.get("fused_signals", [])})
        print(f"🚨 RAW DETECTED OUTPUT: {detected}")
        
        # --- 🚨 THE HACKATHON GOD-MODE FIX: UUID MAPPING ---
        # We store the AI's string ID and map it to a PERFECT database UUID.
        crisis_uuid_map = {} 
        
        crises_list = detected.get("crises_detected", [])
        for crisis in crises_list:
            try:
                ai_crisis_id = crisis.get("id") or crisis.get("cluster_id") or "unknown"
                
                # Generate the perfect UUID and store it in our map!
                real_db_uuid = str(uuid.uuid4())
                crisis_uuid_map[ai_crisis_id] = real_db_uuid

                crisis_type = crisis.get("type", "flood")
                if crisis_type not in ('flood','heatwave','accident','infrastructure','power_outage','protest','disease'):
                    crisis_type = 'infrastructure'
                
                severity = crisis.get("severity", "moderate")
                if severity not in ('critical','high','moderate','low'):
                    severity = 'moderate'

                crisis_payload = {

                    "id": real_db_uuid,  # <-- Forcing the perfect UUID as the Primary Key
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

        # Step 3: Severity Prediction
        print("\n🧠 AI Step 3: Predicting Severity...")
        predicted = await self.severity_predictor.run({"crises_detected": crises_list})

        # Step 4: Resource Allocation (with retry logic)
        print("\n🧠 AI Step 4: Allocating Resources...")
        allocations_list = await self._allocate_with_retry(
            predicted.get("predictions", []),
            available_resources,
            crises_list,
        )

        for allocation in allocations_list:
            ai_crisis_id = allocation.get("crisis_id")

            # Fetch the PERFECT UUID we mapped in Step 2 so the Foreign Key matches!
            real_crisis_uuid = crisis_uuid_map.get(ai_crisis_id)

            # Failsafe: If AI hallucinates an ID, grab the first valid UUID from our map
            if not real_crisis_uuid and crisis_uuid_map:
                real_crisis_uuid = list(crisis_uuid_map.values())[0]

            assigned_resources = allocation.get("assigned_resources", [])
            for res in assigned_resources:
                raw_resource_id = str(res.get("resource_id", ""))

                # Match raw_resource_id against available_resources to find the true UUID or base name
                real_resource_uuid = None
                resource_base_name = None
                for ar in available_resources:
                    ar_id = str(ar.get("id", ""))
                    ar_name = str(ar.get("name", ar.get("base", ar.get("base_name", ""))))
                    if raw_resource_id in (ar_id, ar_name) or (ar_name and ar_name in raw_resource_id):
                        real_resource_uuid = ar_id
                        resource_base_name = ar_name
                        break
                
                if not real_resource_uuid:
                    print(f"⚠️  SKIP: Could not map '{raw_resource_id}' to a known resource.")
                    continue

                # Ensure it's a valid UUID format before DB insert to prevent 22P02 errors
                try:
                    uuid.UUID(real_resource_uuid)
                except ValueError:
                    # If it's a short ID like 'res-001', query the DB to find its true UUID by base_name
                    if resource_base_name:
                        db_match = supabase.table('resources').select('id').eq('base_name', resource_base_name).execute()
                        if db_match.data:
                            real_resource_uuid = db_match.data[0]['id']
                        else:
                            print(f"⚠️  SKIP: Could not find DB UUID for base_name '{resource_base_name}'.")
                            continue
                    else:
                        print(f"⚠️  SKIP: Mapped ID '{real_resource_uuid}' is not a valid UUID format and has no base name.")
                        continue

                try:
                    supabase.table('resources').update({"status": "deployed"}).eq("id", real_resource_uuid).execute()

                    alloc_payload = {
                        "crisis_id": real_crisis_uuid,   # <-- Foreign Key satisfied perfectly
                        "resource_id": real_resource_uuid,
                        "action": res.get("assignment_reason", "Resource dispatched to crisis"),
                        "priority_score": allocation.get("priority_score", 1.0),
                    }
                    supabase.table('allocations').insert(alloc_payload).execute()
                    print(f"✅ DB SUCCESS: Saved allocation record!")
                except Exception as e:
                    print(f"❌ DB ERROR: Allocation insert/update failed: {e}")

        # Step 5: Action Simulation
        print("\n🧠 AI Step 5: Simulating Actions...")
        simulated = await self.action_simulator.run({"allocations": allocations_list})

        # Step 6: Stakeholder Notification
        print("\n🧠 AI Step 6: Generating Notifications...")
        notifications = {}
        for crisis in crises_list:
            notif = await self.stakeholder_notifier.run({
                "crisis": crisis,
                "simulation": simulated,
            })
            # Handle potential missing ID gracefully
            crisis_id = crisis.get("id") or crisis.get("cluster_id") or "unknown"
            notifications[crisis_id] = notif
            ai_crisis_id = crisis.get("id") or crisis.get("cluster_id") or "unknown"
            notifications[ai_crisis_id] = notif
            
            # Fetch the PERFECT UUID we mapped in Step 2!
            real_crisis_uuid = crisis_uuid_map.get(ai_crisis_id)
            if not real_crisis_uuid and crisis_uuid_map:
                real_crisis_uuid = list(crisis_uuid_map.values())[0]

            try:
                message_text = notif.get("public_warning", str(notif))
                if isinstance(message_text, dict):
                    message_text = str(message_text)

                notif_payload = {
                    "crisis_id": real_crisis_uuid,  # <-- Foreign Key satisfied perfectly
                    "audience": "public",
                    "message": message_text
                }
                supabase.table('notifications').insert(notif_payload).execute()
                print("✅ DB SUCCESS: Saved public notification!")
            except Exception as e:
                print(f"❌ DB ERROR: Notification insert failed: {e}")

        trace_logger.log_reasoning("orchestrator", "Pipeline complete", {"phase": "pipeline_end"})

        return {
            "fused_signals": fused,
            "crises_detected": detected,
            "predictions": predicted,
            "allocations": allocated,
            "allocations": allocations_list,
            "simulations": simulated,
            "notifications": notifications,
        }

    async def run_recovery(self, crisis_id: str, verification_data: Dict[str, Any]) -> Dict[str, Any]:
        """Run recovery flow for false alarm or reclassification."""
        return await self.recovery.run({
            "crisis_id": crisis_id,
            "verification_data": verification_data,
        })
    async def _allocate_with_retry(
        self,
        predictions: list,
        available_resources: list,
        crises_list: list,
        max_retries: int = 2,
    ) -> list:
        """
        Calls the ResourceAllocatorAgent with exponential backoff retry.
        If all AI attempts return an empty list, falls back to a deterministic
        rule-based allocator using the REAL data already in the pipeline.
        No dummy data is ever injected.
        """
        for attempt in range(1, max_retries + 1):
            try:
                allocated = await self.resource_allocator.run({
                    "crises_with_predictions": predictions,
                    "available_resources": available_resources,
                })
                allocations_list = allocated.get("allocations", [])

                if allocations_list:
                    print(f"✅ ResourceAllocator succeeded on attempt {attempt}.")
                    return allocations_list

                wait = attempt * 3  # 3s, 6s
                print(f"⚠️  ResourceAllocator returned empty list on attempt {attempt}. Retrying in {wait}s...")
                await asyncio.sleep(wait)

            except Exception as e:
                print(f"❌ ResourceAllocator raised exception on attempt {attempt}: {e}")
                await asyncio.sleep(attempt * 3)

        # All AI attempts exhausted — use deterministic fallback with real data
        print("🔁 All AI allocation attempts failed. Using deterministic fallback allocator with real data.")
        return self._fallback_allocate(crises_list, available_resources)

    def _fallback_allocate(self, crises_list: list, available_resources: list) -> list:
        """
        Deterministic, rule-based fallback allocator.
        Uses the REAL crises and REAL resources from the pipeline — no fake data.
        Matches resource types to crisis types using the same guidelines as the AI prompt.
        Only runs if the AI agent fails all retries.
        """
        RESOURCE_PRIORITY = {
            "flood":          ["rescue_team", "police_unit", "ambulance", "water_tanker"],
            "heatwave":       ["ambulance", "field_team", "generator"],
            "infrastructure": ["field_team", "police_unit", "water_tanker"],
            "accident":       ["ambulance", "police_unit", "rescue_team"],
            "power_outage":   ["generator", "field_team"],
            "protest":        ["police_unit", "field_team"],
            "disease":        ["ambulance", "field_team"],
        }

        available = [r for r in available_resources if r.get("status") == "available"]
        used_ids = set()
        allocations = []

        for crisis in crises_list:
            crisis_id = crisis.get("id") or crisis.get("cluster_id") or "unknown"
            crisis_type = crisis.get("type", "flood")
            desired_types = RESOURCE_PRIORITY.get(crisis_type, ["ambulance"])

            assigned = []
            for desired_type in desired_types:
                for resource in available:
                    rid = resource.get("id", "")
                    if rid not in used_ids and resource.get("type") == desired_type:
                        assigned.append({
                            "resource_id": rid,
                            "resource_type": resource.get("type"),
                            "from_base": resource.get("base", "Unknown"),
                            "eta_minutes": 10,
                            "assignment_reason": f"Fallback rule: {desired_type} assigned to {crisis_type}"
                        })
                        used_ids.add(rid)
                        break  # One resource per type per crisis to avoid monopolizing

            allocations.append({
                "crisis_id": crisis_id,
                "crisis_type": crisis_type,
                "priority_score": 1.0,
                "assigned_resources": assigned,
                "unmet_needs": [],
            })

        print(f"🔁 Fallback allocator produced {len(allocations)} allocation(s) using real resource data.")
        return allocations

    async def run_recovery(self, crisis_id: str, verification_data: Dict[str, Any]) -> Dict[str, Any]:
        return await self.recovery.run({
            "crisis_id": crisis_id,
            "verification_data": verification_data,
        })


if __name__ == "__main__":
    async def main():
        print("🚀 Booting up CIRO AI Pipeline...")
        orchestrator = CIROOrchestrator()
        
        dummy_signals = []
        dummy_resources = [
            {"id": "b3e0d8f0-1234-4567-890a-abcdef123456", "type": "ambulance", "status": "available"}
        ]
        
        await orchestrator.run_pipeline(dummy_signals, dummy_resources)
        print("\n🎉 PIPELINE COMPLETELY FINISHED!")

    asyncio.run(main())
