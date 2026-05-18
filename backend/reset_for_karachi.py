from services.supabase_client import supabase

def total_wipe():
    print("🗑️ Wiping all tables for Karachi move...")
    tables = ['traces', 'crises', 'resources']
    for table in tables:
        # Deleting with a filter that matches everything
        supabase.table(table).delete().neq('id', '00000000-0000-0000-0000-000000000000').execute()
        print(f"✅ {table} cleared.")

if __name__ == "__main__":
    total_wipe()