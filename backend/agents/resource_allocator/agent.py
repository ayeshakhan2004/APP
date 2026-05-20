"""Resource Allocator Agent — optimizes constrained resources across crises."""

from typing import Any, Dict
from agents.base_agent import BaseAgent
from services.gemini_service import ask_gemini
import json


class ResourceAllocatorAgent(BaseAgent):
    def __init__(self):
        super().__init__("resource_allocator")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        crises = input_data.get("crises_with_predictions", [])
        resources = input_data.get("available_resources", [])

        prompt = f"""You are a Crisis Resource Allocation Optimizer for Karachi emergency services.

ACTIVE CRISES (with severity predictions):
{json.dumps(crises, indent=2, default=str)}

AVAILABLE RESOURCES:
{json.dumps(resources, indent=2, default=str)}

Your task:
1. Score each crisis by: urgency × severity × affected_population
2. For each crisis, determine which resource types are needed
3. Allocate resources optimally considering:
   - Travel time from resource location to crisis location (estimate based on lat/lng distance)
   - Resource type match (ambulances for medical, rescue teams for floods, etc.)
   - Don't allocate ALL resources to one crisis — other crises also need help
   - Keep some resources in reserve for new incidents
4. If resources are insufficient, explain the trade-offs
5.CRITICAL: When choosing a resource to allocate, you must use the exact string value found in the 'id' field of the available resources list. Do not use the resource name or type as the resource identifier.

Resource type guidelines:
- Flood: rescue_team (primary), police_unit (traffic), ambulance, water_tanker
- Heatwave: ambulance (primary), field_team (water distribution), generator (cooling centers)
- Infrastructure: field_team (repair), police_unit (area control), water_tanker (if water main)
- Accident: ambulance (primary), police_unit, rescue_team

Return JSON:
{{
  "allocations": [
    {{
      "crisis_id": "string",
      "crisis_type": "string",
      "priority_score": float,
      "assigned_resources": [
        {{
          "resource_id": "string",
          "resource_type": "string",
          "from_base": "string",
          "eta_minutes": int,
          "assignment_reason": "why this resource for this crisis"
        }}
      ],
      "unmet_needs": ["what resources are still needed but unavailable"]
    }}
  ],
  "trade_offs": [
    {{
      "decision": "what trade-off was made",
      "reasoning": "why this was the best option",
      "alternative_considered": "what other option was considered"
    }}
  ],
  "reserves_held": [
    {{
      "resource_id": "string",
      "resource_type": "string",
      "reason": "why held in reserve"
    }}
  ]
}}"""

        system = "You are an expert emergency resource allocation optimizer. You must balance multiple simultaneous crises with limited resources while documenting every trade-off decision."

        result = await ask_gemini(prompt, system)

        allocations = result.get("allocations", [])
        trade_offs = result.get("trade_offs", [])
        
        self.logger.log_reasoning(
            self.name,
            f"Allocated resources across {len(allocations)} crises with {len(trade_offs)} trade-offs",
            {"allocations_count": len(allocations), "trade_offs": trade_offs}
        )

        for tf in trade_offs:
            self.logger.log_reasoning(
                self.name,
                f"Trade-off: {tf.get('decision', '')}",
                {"reasoning": tf.get("reasoning", ""), "alternative": tf.get("alternative_considered", "")}
            )

        return {"allocations": allocations, "trade_offs": trade_offs, "reserves": result.get("reserves_held", [])}
