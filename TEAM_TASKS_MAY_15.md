# 🚨 CIRO — Team Task Sheets (May 15)

> **DAY 2: INTEGRATION DAY**
> Today is May 15. The core scaffolding is done. Today, we connect the pieces. The backend must talk to the database, and the mobile app must talk to the backend.

---

# 👤 MEMBER 1 — SOHAIL (Backend Lead)

> **Goal for Today:** Connect the AI Agents to the Supabase Database. Currently, the agents process mock data and return JSON. Today, they must read from and save to the live database.

### Step 1: Install Supabase Python Client (10 min)
1. Open `backend/requirements.txt` and add: `supabase==2.4.5`
2. Run in your terminal: `pip install -r requirements.txt`

### Step 2: Initialize Supabase Client (15 min)
Create a new file `backend/services/supabase_client.py`:
```python
import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

url: str = os.getenv("SUPABASE_URL", "")
key: str = os.getenv("SUPABASE_KEY", "")

supabase: Client = create_client(url, key)
```

### Step 3: Update the Orchestrator to Save Data (1-2 hours)
Open `backend/agents/orchestrator.py`. Right now, it returns a dictionary. You need to update `run_pipeline` to save the results to Supabase:
1. When `crises_detected` are returned, loop through them and `supabase.table('crises').insert({...}).execute()`
2. When `allocations` are returned, loop through and update the `resources` table to change status to 'deployed'.
3. Update your `TraceLogger` (`backend/utils/trace_logger.py`) to insert logs into the `traces` table in Supabase.

### What "done" looks like today:
✅ When you run the pipeline, new rows appear in the Supabase `crises` and `traces` tables automatically.
✅ Push your code: `git add -A && git commit -m "supabase backend integration" && git push`

---

# 👤 MEMBER 2 — FLUTTER DEVELOPER

> **Goal for Today:** Replace the hardcoded fake data in the mobile app with real data from the Python backend API.

### Step 1: Connect Riverpod to the API Service (30 min)
We already created `api_service.dart`. Now, create `mobile/lib/providers/data_providers.dart`:
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final crisesProvider = FutureProvider<List<dynamic>>((ref) async {
  final api = ref.read(apiServiceProvider);
  // Temporarily fetching from pipeline output, tomorrow we fetch directly from Supabase Realtime
  final result = await api.runPipeline(); 
  return result['crises_detected'] ?? [];
});
```

### Step 2: Update the Dashboard Screen (1 hour)
Open `dashboard_screen.dart`. Change it from a `StatelessWidget` to a `ConsumerWidget` (Riverpod).
- Use `ref.watch(crisesProvider)` to load the data.
- While loading, show a `CircularProgressIndicator`.
- When loaded, update the "Active Crises" counter dynamically based on the list length.

### Step 3: Update the Resource List Screen (1 hour)
Do the same for `resource_list_screen.dart`. Create a provider that fetches from the `/resources` API endpoint and display the real status of the ambulances and rescue teams.

### What "done" looks like today:
✅ The Flutter app shows a loading spinner when it opens, then displays real data from your FastAPI server running on your computer.
✅ Push your code: `git add -A && git commit -m "flutter api integration" && git push`

---

# 👤 MEMBER 3 — DATA & DATABASE ENGINEER

> **Goal for Today:** Build Supabase Edge Functions so that external systems (like a weather API or a citizen reporting app) can push data into our system automatically.

### Step 1: Setup Supabase CLI (15 min)
If you haven't already:
```bash
npx supabase init
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_ID
```

### Step 2: Create the Ingestion Edge Function (1 hour)
Run: `npx supabase functions new ingest-signal`

Open `supabase/functions/ingest-signal/index.ts` and write a Deno script that:
1. Accepts a POST request with JSON data (the signal).
2. Validates that it has a `source` and `location`.
3. Inserts it directly into the `signals` table in Postgres.

### Step 3: Deploy and Test (30 min)
Run `npx supabase functions deploy ingest-signal`.
Test it using Postman or cURL by sending a fake weather alert to your new Edge Function URL. Check the Supabase dashboard to verify the row was created.

### What "done" looks like today:
✅ Edge function is live on Supabase.
✅ Sending a POST request to the function successfully adds a row to the database.
✅ Push your code: `git add -A && git commit -m "ingest edge function" && git push`

---

# 👤 MEMBER 4 — SIMULATION & STRESS-TEST ENGINEER

> **Goal for Today:** Run the AI tests and document exactly how the system behaves under pressure. This is crucial for the judging criteria.

### Step 1: Verify the Gemini API Key (10 min)
Work with Sohail to ensure the `GEMINI_API_KEY` in `.env` is active and has quota. The tests will fail without a working LLM.

### Step 2: Execute the Stress Tests (1 hour)
Run the file `backend/tests/stress_tests.py`.
Watch the terminal output. Pay close attention to:
- How does the AI resolve the contradiction between the social media post and the IoT sensor?
- How does it divide the single ambulance between two different crises?

### Step 3: Document the Results (1 hour)
Create a new file `docs/tests/STRESS_TEST_RESULTS.md`.
Write a detailed report of the execution. Include:
- Scenario Description
- Expected AI Behavior
- Actual AI Behavior (copy-paste the terminal output)
- Why this proves our system is better than standard if/else logic.

### What "done" looks like today:
✅ `STRESS_TEST_RESULTS.md` is complete and proves the robustness of the system.
✅ Push your code: `git add -A && git commit -m "stress test results" && git push`

---

# 👤 MEMBER 5 — DOCS, VIDEO & TRACES LEAD

> **Goal for Today:** Start producing the final deliverables that the judges will actually look at.

### Step 1: Cost & Latency Analysis (1 hour)
Create a file `docs/analysis.md`.
Write a 1-page report detailing:
- How much it costs to run 1 crisis through Gemini 2.0 Flash (hint: it's fractions of a cent).
- What the latency is (how many seconds from signal ingest to notification).
- How the system would scale if 500 crises happened at once (horizontal scaling on Cloud Run).

### Step 2: Record the Antigravity Video (1 hour)
We need a 2-3 minute video proving we used Antigravity.
1. Open a screen recorder (OBS, Loom, or built-in OS recorder).
2. Open the `docs/traces/antigravity_usage_log.md` file you created yesterday.
3. Talk through how Antigravity helped:
   - "First we asked Antigravity to scaffold the project..."
   - "Then it generated the Python code for all 7 agents..."
   - "It even built the Flutter UI screens for us."
4. Save the video as `docs/video/antigravity_demo.mp4`.

### What "done" looks like today:
✅ `analysis.md` is written and polished.
✅ The 2-minute Antigravity proof video is recorded and saved.
✅ Push your code: `git add -A && git commit -m "docs and video recording" && git push`
