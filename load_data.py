import pandas as pd
from sqlalchemy import create_engine

DB_URL = "postgresql://postgres:Putgodfirst-777@localhost:5432/ravenstack"

engine = create_engine(DB_URL)

files = {
    "accounts": r"C:\Users\work\Downloads\archive (3)\ravenstack_accounts.csv",
    "subscriptions": r"C:\Users\work\Downloads\archive (3)\ravenstack_subscriptions.csv",
    "feature_usage": r"C:\Users\work\Downloads\archive (3)\ravenstack_feature_usage.csv",
    "support_tickets": r"C:\Users\work\Downloads\archive (3)\ravenstack_support_tickets.csv",
    "churn_events": r"C:\Users\work\Downloads\archive (3)\ravenstack_churn_events.csv",
}

for table_name, file_path in files.items():
    df = pd.read_csv(file_path)
    df.to_sql(table_name, engine, if_exists="replace", index=False)
    print(f"✅ Loaded {table_name} — {len(df)} rows")

print("All tables loaded successfully")