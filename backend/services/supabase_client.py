import os
from supabase import create_client, Client
from dotenv import load_dotenv



# Load .env from the PROJECT ROOT
load_dotenv()

url: str = os.getenv("SUPABASE_URL", "")
key: str = os.getenv("SUPABASE_KEY", "")
print(f"--- DEBUG URL EXACTLY AS READ: '{url}' ---")

supabase: Client = create_client(url, key)