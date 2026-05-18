# 🚨 CIRO — Team Task Sheets

> **Read YOUR section. Do the tasks IN ORDER. Don't skip steps.**
> Today is May 14. We have 4 days. No time to waste.

---
---

# 👤 MEMBER 1 — SOHAIL (Backend Lead)

> You handle the Python backend and AI agents. Everything that "thinks" is your job.

## Today (May 14) — Do these IN ORDER:

### Step 1: Push to GitHub (15 min)
1. Go to https://github.com/new
2. Create a new repository called `CIRO` (set it to Private)
3. Do NOT check "Add README" (we already have one)
4. After creating, run these commands in your terminal:
```
cd C:\Users\sohail\Desktop\CIRO
git remote add origin https://github.com/YOUR_USERNAME/CIRO.git
git push -u origin main
```
5. Go to repo Settings → Collaborators → Add all 4 teammates by GitHub username

### Step 2: Share the repo link with everyone
- Send the GitHub link in group chat
- Tell everyone: "Clone this repo and read TEAM_TASKS.md"

### Step 3: Set up your .env file (5 min)
1. Go to https://aistudio.google.com/apikey
2. Create a Gemini API key (it's free)
3. Copy `backend/.env.example` to `backend/.env`
4. Paste your Gemini key in the `GEMINI_API_KEY` field

### Step 4: Build the AI Agents (rest of today)
- Come back to Antigravity and say **"build the agents"**
- I (Antigravity) will write the code for all 7 agents
- You just review and test

### What "done" looks like today:
✅ Repo is on GitHub, all teammates have access
✅ All 7 agents have working code (with Gemini)
✅ You can run `python -m uvicorn api.main:app --reload` and it starts

---
---

# 👤 MEMBER 2 — FLUTTER DEVELOPER

> You build the mobile app. You make the thing people SEE and TOUCH.

## Today (May 14) — Do these IN ORDER:

### Step 1: Clone the repo (5 min)
```
git clone https://github.com/SOHAIL_USERNAME/CIRO.git
cd CIRO
```

### Step 2: Create the Flutter project (10 min)
```
cd mobile
flutter create . --org com.ciro --project-name ciro
```
This will create the Flutter project inside the `mobile` folder.

### Step 3: Add these packages to `mobile/pubspec.yaml` (10 min)
Open `mobile/pubspec.yaml` and add these under `dependencies:`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.6.0
  supabase_flutter: ^2.5.0
  flutter_riverpod: ^2.5.0
  http: ^1.2.0
  geolocator: ^12.0.0
  fl_chart: ^0.68.0
  intl: ^0.19.0
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
```
Then run:
```
flutter pub get
```

### Step 4: Build these 5 screens (rest of today)

**Screen 1: Dashboard (Main Screen)**
- Shows a summary: how many active crises, resources deployed, alerts sent
- Use cards with numbers and icons
- This is the home screen when app opens

**Screen 2: Crisis Map**
- Google Map showing Islamabad
- Red markers for active crises
- Green markers for available resources (ambulances, etc.)
- Tap a marker to see details

**Screen 3: Crisis Detail**
- When you tap a crisis, show:
  - Type (flood, heatwave, etc.)
  - Severity (critical, high, moderate, low) with color coding
  - Affected area and population
  - Resources assigned to it
  - Timeline of what happened

**Screen 4: Resource List**
- List of all resources (ambulances, police, rescue teams, etc.)
- Show status: Available (green), Deployed (red), Returning (yellow)
- Show which crisis each resource is assigned to

**Screen 5: Alert Feed**
- List of notifications sent to stakeholders
- Show who it was sent to (public, police, hospital, etc.)
- Show the message content
- Most recent at top

### Design Tips:
- Use dark theme (dark blue/black background, white text)
- Use colors: Red = critical, Orange = high, Yellow = moderate, Green = low/available
- Add loading shimmer effects while data loads
- Use icons from Material Icons

### DON'T worry about:
- Connecting to the backend API (we'll do that tomorrow)
- Real data (use fake/hardcoded data for now)
- Login/authentication (not needed)

### What "done" looks like today:
✅ Flutter app runs on your phone/emulator
✅ All 5 screens exist and you can navigate between them
✅ Screens have hardcoded fake data but look good
✅ Push your code: `git add -A && git commit -m "flutter screens" && git push`

---
---

# 👤 MEMBER 3 — DATA & DATABASE ENGINEER

> You set up the database and make sure data flows in correctly.

## Today (May 14) — Do these IN ORDER:

### Step 1: Clone the repo (5 min)
```
git clone https://github.com/SOHAIL_USERNAME/CIRO.git
cd CIRO
```

### Step 2: Create a Supabase project (15 min)
1. Go to https://supabase.com and sign up (free)
2. Click "New Project"
3. Name it `ciro`
4. Set a database password (SAVE THIS)
5. Choose region closest to Pakistan (Singapore or Mumbai)
6. Wait for it to finish creating (~2 minutes)

### Step 3: Run the database migration (10 min)
1. In Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **New Query**
3. Open the file `supabase/migrations/001_initial_schema.sql` from our repo
4. Copy ALL the SQL code and paste it into the Supabase SQL editor
5. Click **Run**
6. You should see: "Success. No rows returned" — that means it worked
7. Click **Table Editor** in the sidebar — you should see 6 tables:
   - signals, crises, resources, allocations, notifications, traces

### Step 4: Share the Supabase credentials (5 min)
1. In Supabase dashboard, go to **Settings** → **API**
2. Copy these 2 values:
   - `Project URL` (looks like https://xxxxx.supabase.co)
   - `anon public` key (long string starting with "eyJ...")
3. Send both to Sohail so he can put them in the `.env` file

### Step 5: Seed the database with mock data (1-2 hours)
We have mock data files in `backend/mock_data/`. You need to put this data into Supabase.

**Option A (Easy way — manual):**
1. Open each JSON file in `backend/mock_data/`
2. In Supabase Table Editor, click the table (e.g., `signals`)
3. Click "Insert Row" and add the data manually

**Option B (Better way — write a script):**
Create a file `supabase/seed/seed_data.py`:
```python
import json
from supabase import create_client

url = "YOUR_SUPABASE_URL"
key = "YOUR_SUPABASE_KEY"
supabase = create_client(url, key)

# Load and insert signals
for filename in ['social_media_signals', 'weather_signals', 'traffic_signals', 'emergency_calls', 'iot_sensors']:
    with open(f'../../backend/mock_data/{filename}.json') as f:
        data = json.load(f)
    for item in data:
        supabase.table('signals').insert({
            'source': item['source'],
            'raw_data': item,
            'location': item.get('location'),
            'credibility_score': 0.5,
        }).execute()
    print(f"Inserted {filename}")

# Load and insert resources
with open('../../backend/mock_data/resources_inventory.json') as f:
    resources = json.load(f)
for r in resources:
    supabase.table('resources').insert({
        'type': r['type'],
        'status': r['status'],
        'current_lat': r['lat'],
        'current_lng': r['lng'],
        'base_name': r['base'],
    }).execute()
print("Inserted resources")
```
Run it with: `python seed_data.py`

### Step 6: Enable Realtime (5 min)
1. In Supabase dashboard, go to **Database** → **Replication**
2. Make sure these tables have realtime enabled:
   - crises ✅
   - resources ✅
   - notifications ✅
   - traces ✅

### What "done" looks like today:
✅ Supabase project exists with 6 tables
✅ All mock data is in the database
✅ Sohail has the Supabase URL and key
✅ Realtime is enabled
✅ Push any code you wrote: `git add -A && git commit -m "supabase seed" && git push`

---
---

# 👤 MEMBER 4 — SIMULATION & STRESS-TEST ENGINEER

> You make sure our system works under pressure. You try to break it.

## Today (May 14) — Do these IN ORDER:

### Step 1: Clone the repo (5 min)
```
git clone https://github.com/SOHAIL_USERNAME/CIRO.git
cd CIRO
```

### Step 2: Read and understand the system (30 min)
Read these files carefully:
- `README.md` — Section 1 (Architecture) and Section 5 (Stress-Test Strategy)
- `backend/mock_data/` — all 6 JSON files (understand what the data looks like)
- `backend/models/` — all 4 Python files (understand the data structures)

### Step 3: Build the baseline (non-agentic) system (2-3 hours)
This is SUPER IMPORTANT for judging. We need to show that our AI system is BETTER than simple rules.

Create this file: `backend/tests/baseline_comparison.py`

The baseline is a DUMB system that uses simple if/else rules:
```python
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
```

### Step 4: Design the 5 stress-test scenarios (1-2 hours)
Create file: `backend/tests/stress_tests.py`

Write test functions for these 5 scenarios:
1. **Two crises at once** — flood + heatwave fighting for same ambulances
2. **Contradictory signals** — social media says flood, sensor says pipe burst
3. **API failure** — weather API goes down, system must use cached data
4. **False alarm** — flood alert issued, then field report says it's just a pipe burst
5. **Evacuation congestion** — public alert causes traffic jam

For each test, write:
- The input data (you can modify our mock data)
- What the CORRECT output should be
- What would go WRONG if the system wasn't smart

### What "done" looks like today:
✅ `baseline_comparison.py` exists and runs: `python baseline_comparison.py`
✅ `stress_tests.py` has all 5 test scenarios defined
✅ You can explain WHY our AI system is better than the baseline
✅ Push your code: `git add -A && git commit -m "baseline and stress tests" && git push`

---
---

# 👤 MEMBER 5 — DOCS, VIDEO & TRACES LEAD

> You make us LOOK GOOD. Judges see your work first (video + docs).

## Today (May 14) — Do these IN ORDER:

### Step 1: Clone the repo (5 min)
```
git clone https://github.com/SOHAIL_USERNAME/CIRO.git
cd CIRO
```

### Step 2: Read everything (30 min)
- Read `README.md` completely
- Read `docs/traces/CAPTURE_GUIDE.md`
- Read `docs/schemas/data_streams.md`
- Understand what our system does at a high level

### Step 3: Create the architecture diagram (1-2 hours)
Use any tool you like:
- **draw.io** (free, https://app.diagrams.net) — RECOMMENDED
- Figma
- Canva
- Even PowerPoint

**The diagram must show:**
1. The 5 signal sources (social media, weather, traffic, emergency calls, sensors) on the left
2. Arrows going into the "Signal Fusion Agent" box
3. Then arrows flowing through: Crisis Detector → Severity Predictor → Resource Allocator → Action Simulator → Stakeholder Notifier
4. A separate "Recovery Agent" box with dotted lines (for false alarms)
5. "Antigravity Orchestrator" as a big box wrapping all agents
6. Flutter App on top connecting to Supabase
7. Supabase connecting to the Backend

Save the diagram as:
- `docs/architecture/system_architecture.png`
- `docs/architecture/system_architecture.drawio` (editable version)

### Step 4: Start the Antigravity trace document (1 hour)
Create file: `docs/traces/antigravity_usage_log.md`

Start documenting HOW we are using Antigravity:
```markdown
# Antigravity Usage Log

## Session 1: Project Scaffolding (May 14)
- **What we asked**: Set up project structure, define roles, create master plan
- **What Antigravity did**: Created 35 files, defined architecture, assigned team roles
- **Traces**: Antigravity planned folder structure, wrote all agent scaffolds, 
  created mock datasets, designed DB schema
- **Screenshot**: [attach screenshot of Antigravity conversation]

## Session 2: Agent Implementation (May 14)
- **What we asked**: Build working AI agents
- **What Antigravity did**: [fill in after Sohail does this]
```

Take SCREENSHOTS of Antigravity conversations as you go. Save them in `docs/traces/screenshots/`.

### Step 5: Plan the 2 demo videos (30 min)
Create file: `docs/video/video_plan.md`

**Video 1: Main Demo (3-5 minutes)**
```
0:00 - 0:15  Title slide: "CIRO - Crisis Intelligence & Response Orchestrator"
0:15 - 0:45  Show the mobile app dashboard
0:45 - 1:30  Feed in the multi-source signals (show data going in)
1:30 - 2:15  Show crisis detection + classification happening
2:15 - 3:00  Show resource allocation + map visualization
3:00 - 3:45  Show stakeholder notifications being generated
3:45 - 4:15  Show false alarm → recovery flow
4:15 - 4:45  Show baseline comparison (why AI is better)
4:45 - 5:00  Closing slide with team info
```

**Video 2: Antigravity Usage (2-3 minutes)**
```
0:00 - 0:15  Title: "How we used Antigravity"
0:15 - 0:45  Show Antigravity generating project structure
0:45 - 1:30  Show Antigravity writing agent code
1:30 - 2:00  Show Antigravity debugging / decision making
2:00 - 2:30  Show trace logs that Antigravity generated
2:30 - 3:00  Summary of Antigravity's role as orchestrator
```

### What "done" looks like today:
✅ Architecture diagram exists (PNG in docs/architecture/)
✅ Antigravity usage log started with screenshots
✅ Video plan document exists with minute-by-minute script
✅ Push your code: `git add -A && git commit -m "docs and video plan" && git push`

---
---

# 📅 SUMMARY: What MUST be done by end of today (May 14)

| Member | Deliverable | Status |
|--------|------------|--------|
| M1 (Sohail) | GitHub repo live + 7 agents working | ⬜ |
| M2 (Flutter) | 5 Flutter screens with hardcoded data | ⬜ |
| M3 (Database) | Supabase running with all tables + mock data | ⬜ |
| M4 (Testing) | Baseline comparison + 5 stress test scenarios | ⬜ |
| M5 (Docs) | Architecture diagram + video plan + trace log | ⬜ |

---

# 📅 TOMORROW (May 15) — Quick Preview

| Member | Task |
|--------|------|
| M1 | Build API routes, connect agents to Supabase |
| M2 | Connect Flutter app to real backend API |
| M3 | Build Supabase Edge Functions for signal ingestion |
| M4 | Run stress tests against real agents |
| M5 | Start recording Antigravity usage video |

# 📅 May 16 — Integration Day
Everyone connects their parts together. Full pipeline test.

# 📅 May 17 — Polish & Record
Bug fixes. Record both demo videos. Final README. CODE FREEZE at 2 PM.

# 📅 May 18 — Buffer Day
Only if something is broken. Otherwise, rest.

---

> **IMPORTANT: After you finish your tasks, PUSH YOUR CODE.**
> ```
> git add -A
> git commit -m "describe what you did"
> git push
> ```
> Do this EVERY TIME you finish something. Don't wait till the end of the day.
