import requests
import time
import os
from dotenv import load_dotenv

# Load variables from your .env file
load_dotenv("backend/.env")
# Get the URL and Key securely from the environment
SUPABASE_URL = os.getenv("SUPABASE_URL")
ANON_KEY = os.getenv("SUPABASE_KEY")
# Construct the Edge Function URL
url = f"{SUPABASE_URL}/functions/v1/ingest-signal"

# Set up the secure headers
headers = {
    "Authorization": f"Bearer {ANON_KEY}",
    "Content-Type": "application/json"
}

# The fake emergencies
mock_signals = [
    {"source": "social_media", "location": "Karachi Sector 4", "text": "Flood waters rising fast, we are trapped on the roof!"},
    {"source": "emergency_calls", "location": "Clifton Underpass", "text": "Major accident, multiple injuries, need ambulance."},
    {"source": "iot_sensor", "location": "Lyari River", "text": "Water level critical: 4.8 meters. Overflow imminent."},
    {"source": "field_report", "location": "DHA Phase 6", "text": "Power lines down in the water, sparking dangerously!"}
]

print("Starting secure live disaster simulation...")

for signal in mock_signals:
    print(f"Sending signal from {signal['location']}...")
    response = requests.post(url, headers=headers, json=signal)
    
    # Read the actual JSON response from our Edge Function
    response_data = response.json()
    
    # Check if the Edge Function explicitly said "success: true"
    if response_data.get("success") == True:
        print("✅ Actually ingested successfully!")
    else:
        # If it failed, print the exact database error!
        print(f"❌ Failed: {response_data}")
    
    time.sleep(2)

print("Simulation complete! Check your Supabase database.")