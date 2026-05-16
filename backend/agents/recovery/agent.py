"""Recovery Agent — handles false alarms, retractions, corrections."""

from typing import Any, Dict
from agents.base_agent import BaseAgent
from services.gemini_service import ask_gemini
import json


class RecoveryAgent(BaseAgent):
    def __init__(self):
        super().__init__("recovery")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        crisis_id = input_data.get("crisis_id", "")
        original_crisis = input_data.get("original_crisis", {})
        verification_data = input_data.get("verification_data", {})

        prompt = f"""You are a Crisis Recovery and Correction agent. New verification data has arrived that may change or invalidate an existing crisis classification.

ORIGINAL CRISIS:
{json.dumps(original_crisis, indent=2, default=str)}

NEW VERIFICATION DATA:
{json.dumps(verification_data, indent=2, default=str)}

Analyze the new data and decide:
1. Is this a FALSE ALARM? (original crisis was wrong)
2. Does the crisis need RECLASSIFICATION? (different type/severity)
3. Is the original classification CONFIRMED? (verification supports it)

If false alarm or reclassification:
- Draft a retraction/correction message for the public
- Draft notification updates for all stakeholders
- Specify which resources should be recalled or reassigned
- Document the full correction chain

Return JSON:
{{
  "verdict": "false_alarm|reclassification|confirmed",
  "confidence": float,
  "reasoning": "why this verdict was reached",
  "correction_chain": [
    {{"step": 1, "action": "what was done", "detail": "specifics"}}
  ],
  "updated_crisis": {{
    "id": "{crisis_id}",
    "new_type": "string or null if same",
    "new_severity": "string or null if same",
    "new_status": "retracted|active|monitoring",
    "confidence_score": float
  }},
  "retraction_message": {{
    "public": "message for public (null if not false alarm)",
    "emergency_services": "message for emergency services",
    "media": "official correction statement"
  }},
  "resource_actions": [
    {{
      "resource_id": "string",
      "action": "recall|reassign|maintain",
      "reason": "why"
    }}
  ],
  "lessons_learned": "what caused the initial misclassification"
}}"""

        system = "You are a crisis correction specialist. You must carefully analyze new evidence, make accurate corrections, and communicate changes transparently to all stakeholders."

        result = await ask_gemini(prompt, system)

        verdict = result.get("verdict", "unknown")
        self.logger.log_error_recovery(
            self.name,
            f"Original: {original_crisis.get('type', 'unknown')} crisis",
            f"Verdict: {verdict}",
            {"correction_chain": result.get("correction_chain", []), "updated_status": result.get("updated_crisis", {}).get("new_status")}
        )

        return result
