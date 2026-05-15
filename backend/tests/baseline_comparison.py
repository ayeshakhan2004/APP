"""
Baseline (Non-Agentic) Crisis Detection System
This is the SIMPLE version that our AI system must beat.
"""

def baseline_detect_crisis(signals):
    """
    Simple rule-based detection:
    - If rainfall > 50mm AND social posts mention "flood" → alert FLOOD
    - If temperature > 43C → alert HEATWAVE
    - If traffic speed < 10 kmh → alert ROAD BLOCKAGE
    That's it. No intelligence, no credibility scoring, no resource optimization.
    """
    alerts = []
    
    for signal in signals:
        data = signal.get('raw_data', signal)
        source = signal.get('source', data.get('source', ''))
        
        # Simple flood detection
        if source == 'weather':
            if data.get('rainfall_mm_1h', 0) > 50:
                alerts.append({
                    'type': 'flood',
                    'severity': 'high',
                    'confidence': 0.5,  # Always 50% - no verification
                    'method': 'simple_threshold',
                    'note': 'Only checks rainfall > 50mm, ignores contradictions'
                })
        
        # Simple heatwave detection
        if source == 'weather':
            if data.get('temperature_c', 0) > 43:
                alerts.append({
                    'type': 'heatwave',
                    'severity': 'high',
                    'confidence': 0.5,
                    'method': 'simple_threshold',
                    'note': 'Only checks temperature > 43C'
                })
        
        # Simple traffic detection
        if source == 'traffic':
            if data.get('speed_kmh', 50) < 10:
                alerts.append({
                    'type': 'road_blockage',
                    'severity': 'moderate',
                    'confidence': 0.5,
                    'method': 'simple_threshold',
                    'note': 'Only checks speed < 10, no cause analysis'
                })
    
    return alerts


def baseline_allocate_resources(alerts, resources):
    """
    Simple first-come-first-served allocation:
    - No priority scoring
    - No travel time calculation
    - No multi-crisis balancing
    """
    allocations = []
    available = [r for r in resources if r.get('status') == 'available']
    
    for alert in alerts:
        if available:
            resource = available.pop(0)  # Just grab the first one
            allocations.append({
                'alert': alert['type'],
                'resource': resource['type'],
                'method': 'first_come_first_served',
                'note': 'No optimization, no priority, no travel time'
            })
    
    return allocations


# === COMPARISON TABLE (for README/docs) ===
COMPARISON = """
| Feature | Baseline (Simple Rules) | CIRO (Agentic AI) |
|---------|------------------------|-------------------|
| Signal Sources | Checks 1 at a time | Fuses all 5 together |
| Credibility | None | Scores each source 0-1 |
| Contradictions | Ignores them | Detects and resolves |
| False Alarms | Cannot detect | Identifies and retracts |
| Classification | 3 types only | 7 types with confidence |
| Severity | Binary (high/not) | 4 levels with reasoning |
| Resource Allocation | First-come-first-served | Optimized by priority + distance |
| Multi-Crisis | Handles 1 at a time | Coordinates multiple simultaneously |
| Predictions | None | Duration, spread, peak time |
| Stakeholder Comms | None | Tailored per audience |
| Recovery | None | Retracts alerts, corrects classification |
"""

if __name__ == "__main__":
    # Test with our mock data
    import json
    import os
    
    mock_dir = os.path.join(os.path.dirname(__file__), '..', 'mock_data')
    
    all_signals = []
    for fname in ['social_media_signals.json', 'weather_signals.json', 'traffic_signals.json']:
        with open(os.path.join(mock_dir, fname)) as f:
            data = json.load(f)
            for item in data:
                all_signals.append({'source': item['source'], 'raw_data': item})
    
    with open(os.path.join(mock_dir, 'resources_inventory.json')) as f:
        resources = json.load(f)
    
    print("=== BASELINE SYSTEM RESULTS ===")
    print()
    alerts = baseline_detect_crisis(all_signals)
    print(f"Alerts generated: {len(alerts)}")
    for a in alerts:
        print(f"  - {a['type']} ({a['severity']}) | confidence: {a['confidence']} | {a['note']}")
    
    print()
    allocations = baseline_allocate_resources(alerts, resources)
    print(f"Resources allocated: {len(allocations)}")
    for a in allocations:
        print(f"  - {a['resource']} → {a['alert']} | {a['note']}")
    
    print()
    print("=== PROBLEMS WITH BASELINE ===")
    print("1. Does NOT detect the contradictory water-main report")
    print("2. Does NOT handle simultaneous flood + heatwave prioritization")
    print("3. Does NOT check if allocated resource is closest to crisis")
    print("4. Cannot generate stakeholder notifications")
    print("5. Cannot predict how the crisis will evolve")
    print("6. Cannot recover from false alarms")
    print()
    print(COMPARISON)