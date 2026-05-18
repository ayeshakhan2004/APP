"""Resource allocation models"""

from pydantic import BaseModel, Field
from typing import Optional
from enum import Enum
import uuid


class ResourceType(str, Enum):
    AMBULANCE = "ambulance"
    POLICE_UNIT = "police_unit"
    RESCUE_TEAM = "rescue_team"
    SHELTER = "shelter"
    GENERATOR = "generator"
    WATER_TANKER = "water_tanker"
    DRONE = "drone"
    FIELD_TEAM = "field_team"


class ResourceStatus(str, Enum):
    AVAILABLE = "available"
    DEPLOYED = "deployed"
    RETURNING = "returning"


class Resource(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    type: ResourceType
    status: ResourceStatus = ResourceStatus.AVAILABLE
    current_lat: float = 33.6844
    current_lng: float = 73.0479
    assigned_crisis_id: Optional[str] = None
    eta_minutes: Optional[int] = None
