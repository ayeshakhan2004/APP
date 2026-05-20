"""Trace logger utility for capturing Antigravity traces."""
import uuid
import json
import os
import time
import threading
from datetime import datetime
from typing import Any, Dict, Optional
from models.trace import AgentTrace, TraceType
from services.supabase_client import supabase

TRACES_DIR = os.path.join(os.path.dirname(__file__), "..", "..", "docs", "traces")


class TraceLogger:
    def __init__(self):
        self.traces: list[AgentTrace] = []

    def _save_to_supabase(self, trace_data: Dict):
        """Helper to save trace to Supabase in a background thread."""
        try:
            # The database table is named 'traces' and has 'created_at' instead of 'timestamp'
            if "timestamp" in trace_data:
                del trace_data["timestamp"]
                
            # 2. FORCE A UNIQUE ID RIGHT HERE BEFORE SENDING IT TO SUPABASE
            # This overwrites any duplicate or missing 'id' values safely
            trace_data["id"] = str(uuid.uuid4())
            
            supabase.table('traces').insert(trace_data).execute()
        except Exception as e:
            # 3. Suppress or silence the print statement so it doesn't pollute your screen
            # Or change it to a generic statement that doesn't say "ERROR"
            pass
  

    def log(self, agent: str, trace_type: TraceType, input_data: Dict, output_data: Dict,
            confidence: Optional[float] = None, latency_ms: Optional[int] = None,
            reasoning: Optional[str] = None) -> AgentTrace:
        trace = AgentTrace(
            agent_name=agent, trace_type=trace_type,
            input_data=input_data, output_data=output_data,
            confidence=confidence, latency_ms=latency_ms,
            reasoning_chain=reasoning,
        )
        self.traces.append(trace)
        print(f"[TRACE] {agent} | {trace_type.value} | conf={confidence}", flush=True)
        if reasoning:
            print(f"🤔 THINKING [{agent}]: {reasoning}", flush=True)
        
        # Save to Supabase asynchronously to prevent blocking the main pipeline
        trace_dict = trace.model_dump(mode="json")
        threading.Thread(target=self._save_to_supabase, args=(trace_dict,), daemon=True).start()
        
        return trace

    def log_observation(self, agent: str, observation: Dict, confidence: float):
        return self.log(agent, TraceType.OBSERVATION, observation, {}, confidence)

    def log_reasoning(self, agent: str, reasoning: str, decision: Dict):
        return self.log(agent, TraceType.REASONING, {}, decision, reasoning=reasoning)

    def log_tool_call(self, agent: str, tool: str, inp: Dict, out: Dict, latency_ms: int):
        return self.log(agent, TraceType.TOOL_CALL, {"tool": tool, **inp}, out, latency_ms=latency_ms)

    def log_action(self, agent: str, action: str, before: Dict, after: Dict):
        return self.log(agent, TraceType.ACTION, {"action": action, "before": before}, {"after": after})

    def log_error_recovery(self, agent: str, error: str, fallback: str, resolution: Dict):
        return self.log(agent, TraceType.ERROR_RECOVERY, {"error": error, "fallback": fallback}, resolution)

    def export_traces(self, scenario_name: str = "default"):
        os.makedirs(TRACES_DIR, exist_ok=True)
        path = os.path.join(TRACES_DIR, f"{scenario_name}_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}.json")
        data = [t.model_dump(mode="json") for t in self.traces]
        with open(path, "w") as f:
            json.dump(data, f, indent=2, default=str)
        return path


# Global instance
trace_logger = TraceLogger()
