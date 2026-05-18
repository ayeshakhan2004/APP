import json
import os
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client

# 1. DYNAMIC PATHING: Find the Project Root
# This script assumes it is inside CIRO/supabase/seed/
# We go up 2 levels to get to the 'CIRO' folder
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parents[1]  # Goes up two levels (seed -> supabase -> CIRO)

<<<<<<< HEAD
ENV_PATH = PROJECT_ROOT  / ".env"

# Load .env from the PROJECT ROOT
load_dotenv(ENV_PATH)
=======
load_dotenv()
>>>>>>> origin/main
url = os.getenv("SUPABASE_URL")

# Using the key name you mentioned earlier
key = os.getenv("SUPABASE_SERVICE_KEY") or os.getenv("SUPABASE_KEY")

if not url or not key:
    print(f"❌ Error: Credentials missing! URL: {url}, KEY: {'Provided' if key else 'Missing'}")
    exit()

supabase = create_client(url, key)

def seed_data():
    # 2. DYNAMIC FOLDER TARGETING
    # This points exactly to C:/.../CIRO/backend/mock_data/
    mock_data_dir = PROJECT_ROOT / "backend" / "mock_data"

    if not mock_data_dir.exists():
        print(f"❌ Error: Mock data folder not found at {mock_data_dir}")
        return

    # Files to process for the 'signals' table
    signal_files = [
        'social_media_signals', 
        'weather_signals', 
        'traffic_signals', 
        'emergency_calls', 
        'iot_sensors'
    ]
    
    print(f"🚀 Seeding from: {mock_data_dir}")

    for filename in signal_files:
        full_path = mock_data_dir / f"{filename}.json"
        
        if not full_path.exists():
            print(f"⚠️ Warning: File missing at {full_path}")
            continue

        try:
            with open(full_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Map JSON data to Database columns
            to_insert = [{
                'source': item.get('source', filename),
                'raw_data': item,
                'location': item.get('location', 'Unknown'),
                'credibility_score': 0.5,
            } for item in data]
            
            if to_insert:
                supabase.table('signals').insert(to_insert).execute()
                print(f"✅ Batch-inserted {len(to_insert)} items from {filename}")

        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")

    # 3. Dynamic Resources Seeding
    res_path = mock_data_dir / "resources_inventory.json"
    if res_path.exists():
        try:
            with open(res_path, 'r', encoding='utf-8') as f:
                resources = json.load(f)
            
            res_to_insert = [{
                'type': r.get('type'),
                'status': r.get('status'),
                'current_lat': r.get('lat'),
                'current_lng': r.get('lng'),
                'base_name': r.get('base'),
            } for r in resources]
            
            supabase.table('resources').insert(res_to_insert).execute()
            print(f"✅ Successfully seeded {len(res_to_insert)} resources.")
        except Exception as e:
            print(f"❌ Failed to seed resources: {e}")

if __name__ == "__main__":
    seed_data()