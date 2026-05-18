import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load your credentials
load_dotenv()
url: str = os.getenv("SUPABASE_URL", "")
key: str = os.getenv("SUPABASE_KEY", "")

# Connect to Supabase
supabase: Client = create_client(url, key)

# Fetch all records from the 'crises' table
print("Fetching data from Supabase...")
response = supabase.table('resources').select("*").execute()

# Print out what it finds!
print(f"Found {len(response.data)} records in the database:")
for row in response.data:
    print(row)