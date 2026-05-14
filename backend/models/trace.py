"""Antigravity trace models"""

from pydantic import BaseModel, Field
from typing import Any, Dict, Optional
from enum import Enum
from datetime import datetime
import uuid


class TraceType(str, Enum):
    OBSERVATION = "observation"
    REASONING = "reasoning"
    DECISION = "decision"
    TOOL_CALL = "tool_call"
    ACTION = "action"
    ERROR_RECOVERY = "error_recovery"


class AgentTrace(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    agent_name: str
    trace_type: TraceType
    input_data: Dict[str, Any] = {}
    output_data: Dict[str, Any] = {}
    confidence: Optional[float] = None
    latency_ms: Optional[int] = None
    reasoning_chain: Optional[str] = None
    timestamp: datetime = Field(default_factory=datetime.utcnow)
