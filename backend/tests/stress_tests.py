"""
CIRO Robustness Stress Tests
Scenarios defined for Challenge 3: Emergency Response.
"""

import asyncio
import json
import os
from backend.agents.orchestrator import CIROOrchestrator

# Colors for terminal demo
BLUE, GREEN, RED, ENDC, BOLD = "\033[94m", "\033[92m", "\033[91m", "\033[0m", "\033[1m"

async def run_test_case(name, signals, resources, goal, correct_out, failure_risk):
    """Helper to run and print results for each scenario."""
    print(f"\n{BOLD}{BLUE}====================================================")
    print(f"TEST {name}")
    print(f"GOAL: {goal}{ENDC}")
    
    orchestrator = CIROOrchestrator()
    try:
        result = await orchestrator.run_pipeline(signals, resources)
        
        print(f"{GREEN}--- AI Result Analysis ---{ENDC}")
        print(f"{BOLD}Correct Behavior:{ENDC} {correct_out}")
        print(f"{RED}Failure Risk (Without CIRO):{ENDC} {failure_risk}")
        print(f"{BLUE}Actual AI Output:{ENDC}")
        print(json.dumps(result, indent=2))
        
    except Exception as e:
        print(f"{RED}Test Failed with error: {e}{ENDC}")

# --- SCENARIO 1: Multi-Crisis Resource Contention ---
async def scenario_1():
    signals = [
        {"source": "weather", "raw_data": {"type": "flood", "area": "G-10"}},
        {"source": "weather", "raw_data": {"type": "heatwave", "area": "G-7"}}
    ]
    resources = [{"id": "amb-1", "type": "ambulance", "status": "available"}]
    
    await run_test_case(
        "1: RESOURCE CONTENTION", signals, resources,
        "Split 1 ambulance between Flood (G-10) and Heatwave (G-7).",
        "Priority scoring should favor the immediate life-threat (Flood).",
        "A standard system sends resources to the first call, ignoring severity."
    )

# --- SCENARIO 2: Contradictory Signals ---
async def scenario_2():
    signals = [
        {"source": "social_media", "raw_data": {"text": "G-10 is flooding! help!"}},
        {"source": "iot_sensor", "raw_data": {"sensor_type": "water_pressure", "note": "pipe burst"}}
    ]
    
    await run_test_case(
        "2: CONTRADICTORY SIGNALS", signals, [],
        "Resolve Social Media 'Flood' vs Sensor 'Pipe Burst'.",
        "Confidence score should drop; classification should shift to infrastructure.",
        "Dispatching heavy rescue for a plumbing leak wastes critical time."
    )

# --- SCENARIO 3: API Failure Fallback ---
async def scenario_3():
    signals = [{"source": "weather_api", "raw_data": {"status": "503 Service Unavailable"}}]
    
    await run_test_case(
        "3: API FAILURE FALLBACK", signals, [],
        "Handle Weather API outage during active crisis.",
        "System must flag the error and fallback to cached data.",
        "System crash or total loss of situational awareness."
    )

# --- SCENARIO 4: False Alarm -> Correction ---
async def scenario_4():
    signals = [
        {"source": "alert", "raw_data": {"type": "flood_alert", "status": "active"}},
        {"source": "field_report", "raw_data": {"status": "corrected", "note": "False alarm, just a leak"}}
    ]
    
    await run_test_case(
        "4: FALSE ALARM RECOVERY", signals, [],
        "Retract alert when field verification proves it's a false alarm.",
        "Recovery Agent should trigger a retraction/cancellation log.",
        "Public panic and continued unnecessary resource deployment."
    )

# --- SCENARIO 5: Evacuation Congestion ---
async def scenario_5():
    signals = [
        {"source": "traffic_sensor", "raw_data": {"avg_speed": "2km/h", "status": "Gridlock"}},
        {"source": "alert_system", "raw_data": {"msg": "Mass Evacuation in Progress"}}
    ]
    
    await run_test_case(
        "5: EVACUATION CONGESTION", signals, [],
        "Detect traffic jam caused by the evacuation itself.",
        "Suggest phased evacuation or alternative routing.",
        "Emergency vehicles get stuck in the traffic they caused."
    )

async def main():
    print(f"{BOLD}🚀 STARTING CIRO FULL STRESS TEST SUITE{ENDC}")
    await scenario_1()
    await scenario_2()
    await scenario_3()
    await scenario_4()
    await scenario_5()
    print(f"\n{BOLD}{GREEN}ALL SCENARIOS PROCESSED.{ENDC}")

if __name__ == "__main__":
    # Ensure you are in the root directory and run: python -m backend.tests.stress_tests
    asyncio.run(main())