"""CIRO Orchestrator — Main pipeline that chains all agents via Antigravity."""

from typing import Any, Dict, List
from .signal_fusion.agent import SignalFusionAgent
from .crisis_detector.agent import CrisisDetectorAgent
from .severity_predictor.agent import SeverityPredictorAgent
from .resource_allocator.agent import ResourceAllocatorAgent
from .action_simulator.agent import ActionSimulatorAgent
from .stakeholder_notifier.agent import StakeholderNotifierAgent
from .recovery.agent import RecoveryAgent
from ..utils.trace_logger import trace_logger


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

        trace_logger.log_reasoning("orchestrator", "Starting CIRO pipeline with {} signals and {} resources".format(
            len(raw_signals), len(available_resources)
        ), {"phase": "pipeline_start"})

        # Step 1: Signal Fusion
        fused = await self.signal_fusion.run({"signals": raw_signals})

        # Step 2: Crisis Detection
        detected = await self.crisis_detector.run({"fused_signals": fused.get("fused_signals", [])})

        # Step 3: Severity Prediction
        predicted = await self.severity_predictor.run({"crises_detected": detected.get("crises_detected", [])})

        # Step 4: Resource Allocation
        allocated = await self.resource_allocator.run({
            "crises_with_predictions": predicted.get("predictions", []),
            "available_resources": available_resources,
        })

        # Step 5: Action Simulation
        simulated = await self.action_simulator.run({"allocations": allocated.get("allocations", [])})

        # Step 6: Stakeholder Notification
        notifications = {}
        for crisis in detected.get("crises_detected", []):
            notif = await self.stakeholder_notifier.run({
                "crisis": crisis,
                "simulation": simulated,
            })
            notifications[crisis.get("id", "unknown")] = notif

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
