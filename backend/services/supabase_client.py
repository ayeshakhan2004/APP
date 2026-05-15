import os
from supabase import create_client, Client
from dotenv import load_dotenv

# Load variables if they exist, but we are hardcoding below for speed
load_dotenv()

# Your specific Project credentials
url: str = "https://yelrdyaexzgruanlbjgr.supabase.co"
key: str = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllbHJkeWFleHpncnVhbmxiamdyIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODc0Mzc4NiwiZXhwIjoyMDk0MzE5Nzg2fQ.pbdt3g2G6bpy1txJIe05o8QrNjG7kwEAHnVP-tWJmV0"

# Initialize the client
supabase: Client = create_client(url, key)

print("✅ Supabase client initialized and connected.")