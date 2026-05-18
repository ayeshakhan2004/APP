# Data Stream Schemas

## Signal Input Schema (per source)

### Social Media Signal
```json
{
  "id": "string",
  "source": "social_media",
  "platform": "twitter | facebook | instagram",
  "text": "string",
  "user": "string",
  "location": {"lat": "float", "lng": "float", "area": "string"},
  "timestamp": "ISO8601",
  "likes": "int",
  "retweets": "int",
  "urgency_keywords": ["string"]
}
```

### Weather Signal
```json
{
  "id": "string",
  "source": "weather",
  "location": {"lat": "float", "lng": "float"},
  "temperature_c": "float",
  "rainfall_mm_1h": "float",
  "alert_type": "extreme_rain | extreme_heat | storm",
  "alert_severity": "critical | severe | moderate"
}
```

### Traffic Signal
```json
{
  "id": "string",
  "source": "traffic",
  "location": {"lat": "float", "lng": "float", "area": "string"},
  "congestion_level": "severe | heavy | moderate | normal",
  "speed_kmh": "float",
  "normal_speed_kmh": "float",
  "delay_minutes": "int"
}
```

### Emergency Call Signal
```json
{
  "id": "string",
  "source": "emergency_calls",
  "call_type": "flood_rescue | medical_emergency | infrastructure | fire",
  "caller_area": "string",
  "transcript_summary": "string",
  "priority": "critical | high | medium | low"
}
```

### IoT Sensor Signal
```json
{
  "id": "string",
  "source": "iot_sensor",
  "sensor_type": "water_level | temperature | water_pressure | air_quality",
  "reading": "float",
  "unit": "string",
  "threshold": "float",
  "status": "above_threshold | normal | critically_low"
}
```

## Crisis Output Schema
See `backend/models/crisis.py` for the full Pydantic model.

## Resource Allocation Schema
See `backend/models/resource.py` for the full Pydantic model.

## Trace Schema
See `backend/models/trace.py` for the full Pydantic model.
