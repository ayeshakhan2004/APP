"""Crisis data models"""

from pydantic import BaseModel, Field
from typing import Optional, List
from enum import Enum
from datetime import datetime
import uuid


class CrisisType(str, Enum):
    FLOOD = "flood"
    HEATWAVE = "heatwave"
    ACCIDENT = "accident"
    INFRASTRUCTURE = "infrastructure"
    POWER_OUTAGE = "power_outage"
    PROTEST = "protest"
    DISEASE = "disease"


class Severity(str, Enum):
    CRITICAL = "critical"
    HIGH = "high"
    MODERATE = "moderate"
    LOW = "low"


class CrisisStatus(str, Enum):
    ACTIVE = "active"
    MONITORING = "monitoring"
    RESOLVED = "resolved"
    RETRACTED = "retracted"


class Location(BaseModel):
    lat: float
    lng: float
    area_name: str
    radius_km: float = 1.0


class CrisisEvent(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    type: CrisisType
    location: Location
    severity: Severity
    confidence_score: float = Field(ge=0, le=1)
    affected_population: int = 0
    expected_duration_hours: float = 1.0
    peak_impact_time: Optional[datetime] = None
    spread_risk: str = "low"
    status: CrisisStatus = CrisisStatus.ACTIVE
    signal_ids: List[str] = []
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
