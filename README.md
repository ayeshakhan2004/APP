# 🚨 CIRO — Crisis Intelligence & Response Orchestrator

> **AISeekho 2026 Hackathon — Challenge 3**
> Team Size: 5 | Internal Deadline: May 18, 2026 | Submission: May 20, 2026

---

## 1. Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUTTER MOBILE APP                       │
│  Dashboard │ Crisis Map │ Resource View │ Alerts │ Logs     │
└──────────────────────────┬──────────────────────────────────┘
                           │ REST / Realtime (Supabase)
┌──────────────────────────▼──────────────────────────────────┐
│                  SUPABASE (BaaS Layer)                       │
│  Auth │ Postgres DB │ Realtime Subscriptions │ Edge Funcs   │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTP / gRPC
┌──────────────────────────▼──────────────────────────────────┐
│              PYTHON BACKEND (FastAPI on Cloud Run)           │
│                                                             │
│  ┌─────────────┐   ┌──────────────┐   ┌─────────────────┐  │
│  │ Signal Ingest│──▶│ Signal Fusion│──▶│ Crisis Detector │  │
│  │  (3+ sources)│   │   Agent      │   │    Agent        │  │
│  └─────────────┘   └──────────────┘   └───────┬─────────┘  │
│                                                │            │
│  ┌─────────────┐   ┌──────────────┐   ┌───────▼─────────┐  │
│  │  Recovery &  │◀──│   Action     │◀──│    Severity     │  │
│  │  Correction  │   │  Simulator   │   │   Predictor     │  │
│  │    Agent     │   │    Agent     │   │     Agent       │  │
│  └─────────────┘   └──────────────┘   └───────┬─────────┘  │
│                                                │            │
│                    ┌──────────────┐   ┌───────▼─────────┐  │
│                    │ Stakeholder  │◀──│   Resource      │  │
│                    │  Notifier    │   │   Allocator     │  │
│                    │    Agent     │   │     Agent       │  │
│                    └──────────────┘   └─────────────────┘  │
│                                                             │
│  Orchestrated by: Google Antigravity (main controller)      │
│  LLM: Gemini 2.5 Pro/Flash via Vertex AI                   │
└─────────────────────────────────────────────────────────────┘
```

### Signal Sources (minimum 3, we use 5)

| # | Source | Type | Implementation |
|---|--------|------|----------------|
| 1 | Social Media Posts | Citizen reports | Mock dataset + sentiment NLP |
| 2 | Weather API | Environmental | OpenWeatherMap / mock |
| 3 | Traffic/Maps API | Congestion | Google Maps / mock |
| 4 | Emergency Call Logs | Official | Mock dataset |
| 5 | IoT/Field Sensors | Infrastructure | Mock stream |

### Data Flow

1. **Ingest** → Raw signals collected from 5 sources
2. **Fuse** → Signal Fusion Agent correlates, deduplicates, scores credibility
3. **Detect** → Crisis Detector classifies type, location, confidence
4. **Predict** → Severity Predictor estimates radius, population, duration, evolution
5. **Allocate** → Resource Allocator optimizes constrained resources across crises
6. **Simulate** → Action Simulator models before/after states, side effects
7. **Notify** → Stakeholder Notifier sends tailored messages per audience
8. **Recover** → Recovery Agent handles false alarms, retractions, corrections

---

## 2. Team Roles & Work Distribution

### Role Definitions

| Role | Member # | Responsibilities |
|------|----------|-----------------|
| **R1: Backend Lead & Agent Architect** | Member 1 (YOU - Sohail) | FastAPI setup, agent pipeline, Antigravity orchestration, all 7 agents, Vertex AI integration |
| **R2: Flutter Mobile Developer** | Member 2 | Full Flutter app: dashboard, crisis map, resource view, alert feed, real-time updates, UX/UI |
| **R3: Data Engineer & Signal Specialist** | Member 3 | Mock datasets for all 5 sources, Supabase schema/migrations, seed data, signal ingestion endpoints |
| **R4: Simulation & Stress-Test Engineer** | Member 4 | Action simulation logic, stress-test scenarios, robustness/edge cases, false alarm flows, baseline comparison |
| **R5: Docs, Video & Traces Lead** | Member 5 | README polish, architecture diagrams, Antigravity trace capture, demo video (2 videos), cost/scalability analysis |

### Work Distribution Matrix

| Deliverable | R1 | R2 | R3 | R4 | R5 |
|------------|----|----|----|----|-----|
| FastAPI Backend | **Own** | | Support | | |
| 7 Agentic Modules | **Own** | | | Support | |
| Antigravity Integration | **Own** | | | | **Capture** |
| Flutter Mobile App | | **Own** | | | |
| Supabase DB + Auth | | Support | **Own** | | |
| Mock Datasets (5 sources) | | | **Own** | Support | |
| Stress-Test Scenarios | | | | **Own** | |
| Baseline Comparison | | | | **Own** | Support |
| Robustness Evidence | Support | | | **Own** | **Capture** |
| Demo Video (3-5 min) | | Support | | Support | **Own** |
| Antigravity Usage Video (2-3 min) | | | | | **Own** |
| README + Docs | Support | | Support | Support | **Own** |
| Antigravity Traces/Logs | **Generate** | | | | **Collect** |

---

## 3. Day-by-Day Timeline

> **Today is May 14. We have 4 working days. Ship-ready by end of May 17 (buffer day May 18).**

### Day 1 — May 14 (Wed): Foundation Sprint

| Time | R1 (Backend) | R2 (Flutter) | R3 (Data) | R4 (Sim/Test) | R5 (Docs) |
|------|-------------|-------------|-----------|---------------|-----------|
| Morning | FastAPI scaffold, config, models | Flutter project init, theme, navigation shell | Supabase project setup, schema design | Study stress-test scenarios, design test plan | Setup docs structure, start architecture diagram |
| Afternoon | Signal Fusion Agent + Crisis Detector Agent | Dashboard screen + Crisis Map screen (Google Maps) | Create all 5 mock datasets (JSON), write seed scripts | Design simulation state machine (before/after) | Draft data schemas doc, start trace capture guide |
| Evening | Wire agents to Antigravity orchestrator | API service layer (connect to backend) | Supabase migrations + seed DB | Implement baseline (non-agentic) heuristic | Capture first Antigravity traces |

### Day 2 — May 15 (Thu): Core Features

| Time | R1 | R2 | R3 | R4 | R5 |
|------|----|----|----|----|-----|
| Morning | Severity Predictor Agent + Resource Allocator Agent | Resource allocation view + Alert feed screen | Signal ingestion API endpoints + Supabase Edge Functions | Action simulation engine (traffic reroute, dispatch) | Submit challenge selection form (deadline!) |
| Afternoon | Action Simulator Agent + Stakeholder Notifier Agent | Real-time subscription (Supabase realtime) | Connect mock streams to ingestion pipeline | Multi-crisis scenario (2 simultaneous) | Continue trace capture, start cost analysis |
| Evening | Recovery Agent + false alarm flow | Notification display + incident detail screen | End-to-end data flow test | False positive/negative scenario | Architecture diagram finalized |

### Day 3 — May 16 (Fri): Integration & Polish

| Time | R1 | R2 | R3 | R4 | R5 |
|------|----|----|----|----|-----|
| Morning | Full pipeline integration test | UI polish, animations, loading states | Data validation + edge cases in DB | API failure fallback scenario | Record Antigravity usage video (2-3 min) |
| Afternoon | Multi-crisis coordination logic | Impact visualization (before/after charts) | Stakeholder message templates in DB | Evacuation congestion scenario | Record main demo video (3-5 min) |
| Evening | Bug fixes from integration | Bug fixes, responsive layout | Seed production-ready dataset | Full stress-test run + document results | Compile all traces into submission format |

### Day 4 — May 17 (Sat): Final Day

| Time | R1 | R2 | R3 | R4 | R5 |
|------|----|----|----|----|-----|
| Morning | Final bug fixes, performance | Final UI fixes, APK build | Final data cleanup | Baseline comparison write-up | README final draft |
| Afternoon | Code freeze 2 PM | Code freeze 2 PM | Code freeze 2 PM | Code freeze 2 PM | Edit demo videos |
| Evening | Review & approve all docs | Test APK on multiple devices | Verify DB state | Review robustness evidence | **Final submission package ready** |

### May 18 (Sun): Buffer / Emergency Day
- Only if critical bugs found
- Final recording if video needs reshoot
- Team review of complete submission

---

## 4. Antigravity Trace Capture Plan

### What We Must Capture

Every Antigravity interaction must log:

| Trace Element | Where Captured | How |
|--------------|---------------|-----|
| **Workplan** | Agent orchestration startup | Log the initial crisis detection workplan |
| **Task Plan** | Each agent's sub-task breakdown | JSON logs per agent |
| **Observations** | Signal fusion, data analysis | Structured observation logs |
| **Reasoning** | Crisis classification decisions | LLM reasoning chain capture |
| **Decisions** | Resource allocation trade-offs | Decision tree logs with alternatives considered |
| **Tool Calls** | API calls, DB queries | Request/response pairs with timestamps |
| **Action Execution** | Simulation results | Before/after state snapshots |
| **Error Recovery** | False alarm correction, API failures | Error → fallback → resolution chain |
| **Final Outcomes** | Per-crisis resolution | Summary with metrics |

### Capture Method

```python
# backend/utils/trace_logger.py
# Every agent wraps actions in a TraceContext that auto-logs to:
# 1. Supabase `antigravity_traces` table (persistent)
# 2. Local JSON files in docs/traces/ (submission)
# 3. Console output (demo video capture)

class TraceLogger:
    def log_observation(agent, observation, confidence)
    def log_reasoning(agent, reasoning_chain, decision)
    def log_tool_call(agent, tool, input, output, latency_ms)
    def log_action(agent, action, before_state, after_state)
    def log_error_recovery(agent, error, fallback, resolution)
    def export_traces(format="json")  # For submission
```

### Trace Storage

- **Runtime**: Supabase `antigravity_traces` table with realtime subscriptions
- **Export**: `docs/traces/` directory with per-scenario JSON files
- **Video**: Console trace output visible during demo recording

---

## 5. Stress-Test Strategy

### Scenario 1: Multi-Crisis Resource Contention
**Setup**: Flooding in G-10 + Heatwave in G-7 within 30 minutes
**Test**: Resource Allocator must split 5 ambulances, 3 rescue teams, 2 water tankers between crises
**Expected**: Priority scoring, partial allocation, trade-off justification in traces

### Scenario 2: Contradictory Signals
**Setup**: Social media says "flooding" but field sensor says "water main burst"
**Test**: Crisis Detector flags contradiction, requests verification, updates classification
**Expected**: Confidence score adjustment, signal re-weighting, classification update log

### Scenario 3: API Failure Mid-Response
**Setup**: Weather API returns 503 during active crisis processing
**Test**: System falls back to cached weather data (< 1 hour old) or degrades gracefully
**Expected**: Fallback log, degraded confidence notation, manual escalation flag

### Scenario 4: False Alarm → Correction
**Setup**: Initial flood alert issued → field verification confirms only water main burst
**Test**: Recovery Agent retracts public alert, notifies utility company, updates dashboard
**Expected**: Retraction message, updated status, correction log chain

### Scenario 5: Evacuation Congestion
**Setup**: Public alert causes mass evacuation, creating traffic gridlock
**Test**: Action Simulator detects congestion spike, suggests staged alerting
**Expected**: Revised alert strategy, phased evacuation plan, congestion impact comparison

### Baseline Comparison Strategy
- **Non-agentic baseline**: Simple threshold rules (if rainfall > 50mm AND complaints > 10 → alert)
- **Agentic system**: Full multi-agent pipeline with credibility scoring, multi-source fusion, severity prediction
- **Metrics**: Detection accuracy, false positive rate, response time, resource utilization efficiency

---

## 6. Tech Stack

| Component | Technology |
|-----------|-----------|
| Mobile App | Flutter 3.x + Dart |
| State Management | Riverpod |
| Maps | Google Maps Flutter |
| Backend | Python 3.11+ FastAPI |
| LLM | Gemini 2.5 Pro via Vertex AI |
| Orchestrator | Google Antigravity |
| Database | Supabase (PostgreSQL) |
| Realtime | Supabase Realtime |
| Auth | Supabase Auth |
| Hosting | Google Cloud Run |
| CI/CD | GitHub Actions (optional) |

---

## 7. Data Schemas

### Crisis Event

```json
{
  "id": "uuid",
  "type": "flood | heatwave | accident | infrastructure | power_outage | protest | disease",
  "location": { "lat": 33.7, "lng": 73.0, "area_name": "G-10", "radius_km": 2.5 },
  "severity": "critical | high | moderate | low",
  "confidence_score": 0.87,
  "affected_population": 15000,
  "expected_duration_hours": 6,
  "peak_impact_time": "2026-05-14T18:00:00Z",
  "spread_risk": "high",
  "status": "active | monitoring | resolved | retracted",
  "signals": ["signal_id_1", "signal_id_2"],
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Resource

```json
{
  "id": "uuid",
  "type": "ambulance | police_unit | rescue_team | shelter | generator | water_tanker | drone",
  "status": "available | deployed | returning",
  "current_location": { "lat": 33.7, "lng": 73.0 },
  "assigned_crisis_id": "uuid | null",
  "eta_minutes": 15
}
```

### Antigravity Trace

```json
{
  "id": "uuid",
  "agent_name": "signal_fusion | crisis_detector | severity_predictor | ...",
  "trace_type": "observation | reasoning | decision | tool_call | action | error_recovery",
  "input": {},
  "output": {},
  "confidence": 0.92,
  "latency_ms": 340,
  "timestamp": "ISO8601"
}
```

---

## 8. Setup Instructions

```bash
# Clone
git clone <repo-url> && cd CIRO

# Backend
cd backend
python -m venv venv && source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
cp .env.example .env  # Fill in API keys
uvicorn api.main:app --reload

# Mobile
cd mobile
flutter pub get
flutter run

# Supabase
npx supabase init
npx supabase db push
npx supabase functions deploy
```

---

## 9. Cost & Latency Analysis

| Operation | Estimated Cost | Latency |
|-----------|---------------|---------|
| Gemini 2.5 Pro (per crisis analysis) | ~$0.02 | ~2-4s |
| Signal fusion (5 sources) | ~$0.01 | ~1-2s |
| Full pipeline (detect → respond) | ~$0.05 | ~8-15s |
| Supabase DB operations | Free tier | ~50ms |
| Google Maps API | Free tier ($200/mo credit) | ~200ms |

### Scalability Discussion
- **10x scale** (50 simultaneous crises): Horizontal Cloud Run scaling, batch processing, estimated $0.50/cycle
- **100x scale** (500 crises): Requires pub/sub queue, dedicated Vertex AI endpoints, estimated $5/cycle, ~30s latency
- **Bottleneck**: LLM inference; mitigated by caching similar crisis patterns and using Flash for routine classification

---

## 10. Privacy & Safety

- No real personal data used — all datasets are synthetic/mock
- Social media posts are fictional and do not reference real individuals
- Location data uses real Islamabad sector names for realism but fictional events
- All API keys stored in environment variables, never committed
- Alert messages include "THIS IS A SIMULATION" watermark in demo

---

## 11. Limitations

1. Mock data only — no live API connections in prototype
2. Resource allocation is modeled, not connected to real dispatch systems
3. Map visualization uses static crisis zones, not real-time GIS
4. LLM responses may vary between runs (mitigated by structured output prompts)
5. Single-city scope (Islamabad) — multi-city would require schema changes

---

*Built with ❤️ for AISeekho 2026 by Team CIRO*
