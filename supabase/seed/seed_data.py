import json
import os
from supabase import create_client

# --- CONFIGURATION ---
URL = "https://yelrdyaexzgruanlbjgr.supabase.co"
KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbHJkeWFleHpncnVhbmxiamdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg3NDM3ODYsImV4cCI6MjA5NDMxOTc4Nn0.bIxB5DtBKdzMQ2Wf2wx-yb1lq5H6ENAEka8Z08XblKc"

supabase = create_client(URL, KEY)

# Aapki exact directory ka rasta
BASE_PATH = r"F:\Projects\Hackathon\AISEEKHO-CIRO\backend\mock_data"

def seed_signals():
    filenames = ['social_media_signals', 'weather_signals', 'traffic_signals', 'emergency_calls', 'iot_sensors']
    
    for name in filenames:
        # Full path banaya ja raha hai
        path = os.path.join(BASE_PATH, f"{name}.json")
        
        if os.path.exists(path):
            with open(path, 'r') as f:
                data = json.load(f)
                print(f"Uploading {len(data)} items from {name}...")
                for item in data:
                    supabase.table('signals').insert({
                        'source': item.get('source', name),
                        'raw_data': item,
                        'location': str(item.get('location', '')),
                        'credibility_score': 0.5
                    }).execute()
            print(f"✅ {name} uploaded!")
        else:
            print(f"❌ File nahi mili: {path}")

def seed_resources():
    path = os.path.join(BASE_PATH, "resources_inventory.json")
    
    if os.path.exists(path):
        with open(path, 'r') as f:
            resources = json.load(f)
            print(f"Uploading {len(resources)} resources...")
            for r in resources:
                supabase.table('resources').insert({
                    'type': r.get('type', 'unknown'),
                    'status': r.get('status', 'available'),
                    'current_lat': r.get('lat', 0.0),
                    'current_lng': r.get('lng', 0.0),
                    'base_name': r.get('base', 'Main Base'),
                }).execute()
        print("✅ Resources inventory uploaded!")
    else:
        print(f"❌ File nahi mili: {path}")

if __name__ == "__main__":
    print("--- CIRO Database Seeding Started ---")
    seed_signals()
    seed_resources()
    print("--- All Done! Check your Supabase Dashboard ---")