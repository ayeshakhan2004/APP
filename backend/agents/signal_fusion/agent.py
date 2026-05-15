"""Signal Fusion Agent — correlates and deduplicates signals from multiple sources."""

from typing import Any, Dict
from ..base_agent import BaseAgent
from ...services.gemini_service import ask_gemini
import json


class SignalFusionAgent(BaseAgent):
    def __init__(self):
        super().__init__("signal_fusion")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        signals = input_data.get("signals", [])

        prompt = f"""You are a Crisis Signal Fusion analyst. You receive raw signals from multiple sources about potential crises in Islamabad, Pakistan.

SIGNALS DATA:
{json.dumps(signals, indent=2, default=str)}

Your task:
1. Group signals that refer to the SAME incident by geographic proximity (within 2km) and topic similarity
2. For each group, score the credibility of each source (0.0 to 1.0):
   - Official sensors/emergency calls: 0.8-1.0
   - Weather API data: 0.8-0.9
   - Traffic API data: 0.7-0.9
   - Citizen social media posts with specific details: 0.5-0.7
   - Vague social media posts: 0.2-0.4
3. Detect contradictions between signals in the same group
4. Calculate a fused confidence score for each cluster
5. Flag any suspicious or low-confidence signals

Return JSON:
{{
  "clusters": [
    {{
      "cluster_id": "string",
      "probable_incident": "brief description",
      "location": {{"lat": float, "lng": float, "area": "string"}},
      "signals": ["signal_id_1", "signal_id_2"],
      "credibility_scores": {{"signal_id": score}},
      "fused_confidence": float,
      "contradictions": ["description of contradiction"],
      "mention_velocity": int,
      "urgency_level": "critical|high|moderate|low"
    }}
  ],
  "flagged_signals": [
    {{
      "signal_id": "string",
      "reason": "why flagged"
    }}
  ],
  "summary": "brief overall assessment"
}}"""

        system = "You are an expert crisis intelligence analyst specializing in multi-source signal fusion and credibility assessment."
        
        result = await ask_gemini(prompt, system)
        
        self.logger.log_reasoning(
            self.name,
            f"Fused {len(signals)} signals into clusters",
            {"clusters": len(result.get("clusters", [])), "contradictions_found": sum(len(c.get("contradictions", [])) for c in result.get("clusters", []))}
        )

        return {"fused_signals": result.get("clusters", []), "flagged": result.get("flagged_signals", []), "summary": result.get("summary", "")}
