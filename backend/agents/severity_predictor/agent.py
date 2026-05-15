"""Severity Predictor Agent — estimates impact radius, population, duration, evolution."""

from typing import Any, Dict
from ..base_agent import BaseAgent
from ...services.gemini_service import ask_gemini
import json


class SeverityPredictorAgent(BaseAgent):
    def __init__(self):
        super().__init__("severity_predictor")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        crises = input_data.get("crises_detected", [])

        prompt = f"""You are a Crisis Severity and Evolution Prediction system for Islamabad, Pakistan.

DETECTED CRISES:
{json.dumps(crises, indent=2, default=str)}

For each crisis, predict:
1. Affected radius in km
2. Estimated affected population (Islamabad sectors have ~20,000-50,000 people each)
3. Expected duration in hours
4. Peak impact time (how many hours from now will it be worst)
5. Spread risk (will it get bigger?)
6. Uncertainty range (how confident are you in these predictions)
7. Evolution trajectory (what will happen next)

Context about Islamabad:
- G-sectors are residential (G-6 through G-15)
- F-sectors are mixed residential/commercial
- Population density: ~2,000 people per sq km in residential sectors
- Monsoon season floods can last 6-24 hours
- Heatwaves in May can last 2-5 days
- Water main bursts typically resolved in 4-8 hours

Return JSON:
{{
  "predictions": [
    {{
      "crisis_id": "string",
      "affected_radius_km": float,
      "affected_population": int,
      "expected_duration_hours": float,
      "peak_impact_time_hours_from_now": float,
      "spread_risk": "high|moderate|low",
      "spread_direction": "description of likely spread",
      "uncertainty_range": "narrow|moderate|wide",
      "evolution_trajectory": [
        {{"time": "+1h", "prediction": "what happens"}},
        {{"time": "+3h", "prediction": "what happens"}},
        {{"time": "+6h", "prediction": "what happens"}}
      ],
      "vulnerable_groups": ["elderly", "children", "outdoor workers"],
      "secondary_risks": ["power outage", "traffic gridlock", "hospital overflow"]
    }}
  ]
}}"""

        system = "You are an urban crisis severity prediction expert with deep knowledge of Islamabad's geography, infrastructure, and population patterns."

        result = await ask_gemini(prompt, system)

        predictions = result.get("predictions", [])
        self.logger.log_reasoning(
            self.name,
            f"Generated severity predictions for {len(predictions)} crises",
            {"predictions_summary": [{"crisis_id": p.get("crisis_id"), "duration_h": p.get("expected_duration_hours"), "population": p.get("affected_population")} for p in predictions]}
        )

        return {"predictions": predictions}
