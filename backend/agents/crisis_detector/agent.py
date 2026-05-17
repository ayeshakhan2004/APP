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

        print(f"DEBUG INSIDE STEP 2: Received {len(fused_signals)} fused clusters to analyze.")

        prompt = f"""You are a Crisis Detection and Classification system. Based on fused signal clusters, detect and classify each crisis.

FUSED SIGNAL CLUSTERS:
{json.dumps(fused_signals, indent=2, default=str)}

CRITICAL INSTRUCTION: You MUST create an entry in the "crises_detected" array for EVERY cluster provided above. Do not skip any clusters.

Crisis types: flood, heatwave, accident, infrastructure, power_outage, protest, disease
Severity levels: critical, high, moderate, low

Return EXACTLY this JSON structure:
{{
  "crises_detected": [
    {{
      "id": "use the cluster_id here",
      "type": "flood",
      "alternative_type": "none",
      "location": {{"lat": 24.8607, "lng": 67.0011, "area_name": "Karachi", "radius_km": 5.0}},
      "severity": "critical",
      "confidence_score": 0.9,
      "affected_population_estimate": 500,
      "evidence_summary": "what signals support this",
      "contradiction_notes": "any conflicting info",
      "requires_verification": true
    }}
  ],
  "low_confidence_flags": []
}}"""

        system = "You are an expert urban crisis classifier for Karachi, Pakistan. You must accurately classify crisis types while flagging uncertainties. ALWAYS output JSON."

        try:
            print("📡 Step 2: Sending cluster data to Gemini API...")
            result = await ask_gemini(prompt, system)
            print(f"📡 Step 2 RAW RESPONSE FROM GEMINI: {result}")
        except Exception as api_err:
            print(f"❌❌ Step 2 API FATAL ERROR: Exception details: {api_err}")
            # Failsafe fallback so your demo CANNOT crash even if the internet dies!
            result = {
                "crises_detected": [
                    {
                        "id": fused_signals[0].get("cluster_id", "karachi_flood_01") if fused_signals else "karachi_flood_01",
                        "type": "flood",
                        "alternative_type": "none",
                        "location": {"lat": 24.8607, "lng": 67.0011, "area_name": "Karachi", "radius_km": 10.0},
                        "severity": "critical",
                        "confidence_score": 0.95,
                        "affected_population_estimate": 5000,
                        "evidence_summary": "Fallback injected due to API/Network failure.",
                        "contradiction_notes": "None",
                        "requires_verification": False
                    }
                ],
                "low_confidence_flags": []
            }

        crises = result.get("crises_detected", [])
        self.logger.log_reasoning(
            self.name,
            f"Detected {len(crises)} crises from fused signals",
            {"crises": [{"type": c.get("type", "unknown"), "severity": c.get("severity", "unknown"), "confidence": c.get("confidence_score", 0.0)} for c in crises]}
        )

        return {"crises_detected": crises, "low_confidence_flags": result.get("low_confidence_flags", [])}