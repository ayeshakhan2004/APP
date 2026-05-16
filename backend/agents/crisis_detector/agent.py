"""Crisis Detector Agent — classifies crisis type, location, severity, confidence."""

from typing import Any, Dict
from agents.base_agent import BaseAgent
from services.gemini_service import ask_gemini
import json


class CrisisDetectorAgent(BaseAgent):
    def __init__(self):
        super().__init__("crisis_detector")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        fused_signals = input_data.get("fused_signals", [])

        prompt = f"""You are a Crisis Detection and Classification system. Based on fused signal clusters, detect and classify each crisis.

FUSED SIGNAL CLUSTERS:
{json.dumps(fused_signals, indent=2, default=str)}

For each cluster that represents a real crisis, classify it:

Crisis types: flood, heatwave, accident, infrastructure, power_outage, protest, disease
Severity levels: critical, high, moderate, low

Consider:
- Multiple signals confirming = higher confidence
- Contradictions = lower confidence, flag for verification
- Emergency calls + sensor data = strongest evidence
- Social media alone = needs verification
- If a "flood" has contradicting evidence of "water main burst", note BOTH possibilities

Return JSON:
{{
  "crises_detected": [
    {{
      "id": "crisis_001",
      "type": "flood|heatwave|accident|infrastructure|power_outage|protest|disease",
      "alternative_type": "null or alternative classification if contradictions exist",
      "location": {{"lat": float, "lng": float, "area_name": "string", "radius_km": float}},
      "severity": "critical|high|moderate|low",
      "confidence_score": float,
      "affected_population_estimate": int,
      "evidence_summary": "what signals support this classification",
      "contradiction_notes": "any conflicting information",
      "requires_verification": true/false
    }}
  ],
  "low_confidence_flags": [
    {{
      "cluster_id": "string",
      "issue": "why confidence is low",
      "recommended_action": "what to do about it"
    }}
  ]
}}"""

        system = "You are an expert urban crisis classifier for Karachi, Pakistan. You must accurately classify crisis types while flagging uncertainties."

        result = await ask_gemini(prompt, system)

        crises = result.get("crises_detected", [])
        self.logger.log_reasoning(
            self.name,
            f"Detected {len(crises)} crises from fused signals",
            {"crises": [{"type": c.get("type"), "severity": c.get("severity"), "confidence": c.get("confidence_score")} for c in crises]}
        )

        return {"crises_detected": crises, "low_confidence_flags": result.get("low_confidence_flags", [])}
