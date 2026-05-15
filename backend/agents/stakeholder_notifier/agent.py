"""Stakeholder Notifier Agent — generates tailored messages per audience."""

from typing import Any, Dict
from ..base_agent import BaseAgent
from ...services.gemini_service import ask_gemini
import json


class StakeholderNotifierAgent(BaseAgent):
    def __init__(self):
        super().__init__("stakeholder_notifier")

    async def execute(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        crisis = input_data.get("crisis", {})
        simulation = input_data.get("simulation", {})

        prompt = f"""You are a Crisis Communication Specialist. Generate tailored notification messages for different stakeholders about an active crisis.

CRISIS DETAILS:
{json.dumps(crisis, indent=2, default=str)}

RESPONSE SIMULATION:
{json.dumps(simulation, indent=2, default=str)}

Generate messages for EACH of these 6 audiences. Each message must be appropriate for that audience:

1. **Public** — Simple, clear, actionable. No jargon. Include: what to do, where to go, what to avoid.
2. **Emergency Services** — Technical, precise. Include: coordinates, severity, resources deployed, access routes.
3. **Hospitals** — Medical focus. Include: expected patient count, injury types, ETA of ambulances.
4. **Utility Companies** — Infrastructure focus. Include: affected infrastructure, location, urgency of repair.
5. **Transport Authority** — Traffic focus. Include: affected roads, suggested reroutes, duration.
6. **Media/Command Center** — Formal situation report. Include: incident summary, response actions, official statement.

Return JSON:
{{
  "notifications": {{
    "public": {{
      "title": "string",
      "message": "string (max 280 chars for SMS)",
      "full_message": "string (detailed version)",
      "channels": ["sms", "app_push", "radio"],
      "urgency": "immediate|high|normal"
    }},
    "emergency_services": {{
      "title": "string",
      "message": "string",
      "priority_code": "P1|P2|P3",
      "coordinates": "lat, lng",
      "channels": ["radio", "dispatch_system"]
    }},
    "hospitals": {{
      "title": "string",
      "message": "string",
      "expected_patients": int,
      "injury_types": ["string"],
      "channels": ["hospital_network", "phone"]
    }},
    "utility_companies": {{
      "title": "string",
      "message": "string",
      "affected_infrastructure": "string",
      "repair_urgency": "immediate|scheduled",
      "channels": ["email", "phone"]
    }},
    "transport_authority": {{
      "title": "string",
      "message": "string",
      "affected_roads": ["string"],
      "suggested_reroutes": ["string"],
      "channels": ["traffic_system", "radio"]
    }},
    "media_command_center": {{
      "title": "string",
      "situation_report": "string",
      "official_statement": "string",
      "channels": ["press_release", "dashboard"]
    }}
  }}
}}"""

        system = "You are an expert crisis communications specialist who writes clear, audience-appropriate emergency notifications."

        result = await ask_gemini(prompt, system)

        notifications = result.get("notifications", {})
        for audience, notif in notifications.items():
            self.logger.log_action(
                self.name,
                f"notify_{audience}",
                {"crisis": crisis.get("type", "unknown")},
                {"title": notif.get("title", ""), "channels": notif.get("channels", [])}
            )

        return {"notifications": notifications}
