"""Signal source data models"""

from pydantic import BaseModel, Field
from typing import Optional, Dict, Any
from enum import Enum
from datetime import datetime
import uuid


class SignalSource(str, Enum):
    SOCIAL_MEDIA = "social_media"
    WEATHER = "weather"
    TRAFFIC = "traffic"
    EMERGENCY_CALLS = "emergency_calls"
    IOT_SENSOR = "iot_sensor"
    FIELD_REPORT = "field_report"


class Signal(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    source: SignalSource
    raw_data: Dict[str, Any]
    location: Optional[Dict[str, float]] = None  # {"lat": ..., "lng": ...}
    credibility_score: float = Field(default=0.5, ge=0, le=1)
    urgency_score: float = Field(default=0.5, ge=0, le=1)
    contradiction_level: float = Field(default=0.0, ge=0, le=1)
    is_verified: bool = False
    timestamp: datetime = Field(default_factory=datetime.utcnow)
