# Backend & Database Master Plan

This plan specifically isolates the **Python Backend (FastAPI + AI Agents)** and the **Supabase Database** to give you a clear, structured roadmap of exactly what you have accomplished and what you need to build next to win the hackathon.

## User Review Required

> [!IMPORTANT]
> Since you are taking ownership of executing these remaining tasks, please review the **"What Is Left (Step-by-Step Action Plan)"** section carefully. If you approve, you can start building these components immediately!

---

## 1. What Is DONE (Features We Have Added)

### Database (Supabase)
- **Table Schema:** All 6 required tables exist (`signals`, `crises`, `resources`, `allocations`, `notifications`, `traces`).
- **Data Migration:** Mock data is successfully seeded and coordinates are migrated to Karachi.
- **Realtime:** Realtime subscriptions are enabled for mobile app syncing.
- **Edge Functions:** The `ingest-signal` Edge Function is deployed and successfully ingesting live simulated disaster data (verified via `simulate_demo.py`).

### Backend (FastAPI & AI Agents)
- **AI Agent Pipeline:** The 7-agent Antigravity pipeline is fully written and tested using Gemini 2.5.
- **Trace Logging:** The system flawlessly captures LLM reasoning and saves it to the `traces` table in Supabase without schema errors.
- **Stress Testing:** The robustness suite (`stress_tests.py`) successfully proves the AI handles resource contention, API failures, and false alarms better than a standard rule-based system.
- **Partial DB Integration:** The `CIROOrchestrator` successfully saves detected crises to the `crises` table and updates `resources` to a "deployed" status.

---

## 2. What Is LEFT (Missing Features)

These are the features explicitly requested in your `README.md` and `TEAM_TASKS.md` that are currently missing from the codebase:

1. **Database Inserts for Allocations & Notifications**
   - *Why it's missing:* Your `orchestrator.py` runs the Allocator and Notifier agents, but never actually saves their output to the Supabase tables.
   - *Why it matters:* If they aren't in the database, the Flutter mobile app cannot show the Alert Feed or Resource maps.
2. **Database Updates for the Recovery Agent**
   - *Why it's missing:* The Recovery Agent runs, but it doesn't update the database to mark a crisis as "retracted" or free up deployed resources.
   - *Why it matters:* False alarm recovery is a massive selling point of your AI system. The database must reflect the correction.

---

## 3. What You Need To Do (Step-by-Step Action Plan)

Here is your exact checklist to finish the Backend & Database.

### Step 1: Complete the `orchestrator.py` Database Hooks
Open `backend/agents/orchestrator.py` and scroll down to where the `resource_allocator` and `stakeholder_notifier` agents run. Add these database inserts:

1. **Save Allocations:** Loop through the `allocations_list`. For every resource assigned to a crisis, execute:
   `supabase.table('allocations').insert({"crisis_id": ..., "resource_id": ..., "status": "active"}).execute()`
2. **Save Notifications:** Loop through the `notifications` dictionary. For every message generated, execute:
   `supabase.table('notifications').insert({"crisis_id": ..., "audience": "public", "message": ...}).execute()`

### Step 2: Implement Database Logic for the Recovery Agent
In `orchestrator.py`, inside the `run_recovery` function:
1. Update the `crises` table to change the status of the false-alarm crisis to `retracted`.
   `supabase.table('crises').update({"status": "retracted"}).eq("id", crisis_id).execute()`
2. Update the `resources` table to change all resources deployed to that `crisis_id` back to `available`.

### Step 3: Final End-to-End Test
Once the above 2 steps are coded:
1. Run your `simulate_demo.py` script to generate a live signal via the Edge Function.
2. Run `python -m uvicorn api.main:app --reload` and execute the pipeline.
3. Check your Supabase dashboard to verify that **Crises, Resources, Allocations, Notifications, and Traces** have all been generated and saved flawlessly.

---

## Verification Plan
When you finish writing the code for Step 1 and Step 2, you should run the pipeline and manually check the Supabase Table Editor. If rows appear in every single table, the Backend & Database track of the hackathon is 100% complete!
