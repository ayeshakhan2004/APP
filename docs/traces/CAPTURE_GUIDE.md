# Antigravity Trace Capture Guide

## Purpose
This document explains how to capture Antigravity traces for the hackathon submission.

## What Judges Want to See
1. **Workplan** — How the orchestrator plans its approach
2. **Task Plan** — Sub-tasks assigned to each agent
3. **Observations** — What each agent observes from input data
4. **Reasoning** — Why decisions were made (LLM reasoning chains)
5. **Decisions** — Final choices with alternatives considered
6. **Tool Calls** — Every API call, DB query, with input/output
7. **Action Execution** — Before/after state for every action
8. **Error Recovery** — How the system handles failures
9. **Final Outcomes** — Resolution summary with metrics

## How to Capture

### Method 1: Automatic (via TraceLogger)
All agents automatically log traces through `backend/utils/trace_logger.py`.
Run any pipeline scenario and traces are captured to:
- Console output (visible in demo video)
- `docs/traces/` directory (JSON files for submission)
- Supabase `traces` table (persistent storage)

### Method 2: Antigravity IDE Traces
- Keep Antigravity open during development
- All planning, code generation, and debugging sessions are logged
- Export traces from Antigravity for the 2-3 minute usage video

### Method 3: Manual Screenshot/Recording
- Record screen during pipeline execution
- Capture the trace console output
- Include in demo video

## Export for Submission
```bash
cd backend
python -c "from utils.trace_logger import trace_logger; trace_logger.export_traces('final_submission')"
```

## Trace File Naming Convention
- `scenario_flooding_YYYYMMDD_HHMMSS.json`
- `scenario_heatwave_YYYYMMDD_HHMMSS.json`
- `scenario_false_alarm_YYYYMMDD_HHMMSS.json`
- `scenario_multi_crisis_YYYYMMDD_HHMMSS.json`
- `scenario_api_failure_YYYYMMDD_HHMMSS.json`
