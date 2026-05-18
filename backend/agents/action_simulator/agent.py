"""Action Simulator Agent — models before/after states for response actions."""

from typing import Any, Dict
from agents.base_agent import BaseAgent
from services.gemini_service import ask_gemini
import json


class ActionSimulatorAgent(BaseAgent):
    def __init__(self):
        super().__init__("action_simulator")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        allocations = input_data.get("allocations", [])

<<<<<<< HEAD
        prompt = f"""You are a Crisis Response Action Simulator for Islamabad. You model the BEFORE and AFTER states of response actions.
=======
        prompt = f"""You are a Crisis Response Action Simulator for Karachi. You model the BEFORE and AFTER states of response actions.
>>>>>>> origin/main

RESOURCE ALLOCATIONS:
{json.dumps(allocations, indent=2, default=str)}

For each allocation, simulate these response actions:
1. Emergency dispatch (ambulances, rescue teams deployed)
2. Traffic rerouting (police redirect traffic around crisis zone)
3. Public alert (warning sent to citizens)
4. Hospital preparation (nearby hospitals alerted for incoming patients)
5. Utility escalation (if infrastructure issue, utility company notified)

For EACH action, provide:
- Before state (what the situation looks like now)
- The response action taken
- After state (expected result)
- Response time improvement (how much faster is response vs no action)
- Congestion impact (does this action create traffic/crowding?)
- Resource cost (resources consumed)
- Possible side effects (unintended consequences)

Return JSON:
{{
  "simulations": [
    {{
      "crisis_id": "string",
      "actions": [
        {{
          "action_type": "emergency_dispatch|traffic_reroute|public_alert|hospital_prep|utility_escalation",
          "description": "what is being done",
          "before_state": {{
            "response_time_minutes": int,
            "congestion_level": "string",
            "public_awareness": "string",
            "resource_status": "string"
          }},
          "after_state": {{
            "response_time_minutes": int,
            "congestion_level": "string",
            "public_awareness": "string",
            "resource_status": "string"
          }},
          "response_time_improvement_pct": float,
          "congestion_impact": "reduced|unchanged|increased",
          "resource_cost": "string",
          "side_effects": ["possible side effect"],
          "success_probability": float
        }}
      ],
      "overall_impact": "summary of all actions combined"
    }}
  ]
}}"""

        system = "You are an expert crisis response simulator who models realistic before/after scenarios for emergency response actions in urban environments."

        result = await ask_gemini(prompt, system)

        simulations = result.get("simulations", [])
        for sim in simulations:
            for action in sim.get("actions", []):
                self.logger.log_action(
                    self.name,
                    action.get("action_type", "unknown"),
                    action.get("before_state", {}),
                    action.get("after_state", {})
                )

        return {"simulations": simulations}
