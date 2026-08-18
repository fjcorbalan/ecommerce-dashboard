import sqlite3
import pandas as pd

# ----------------------------
# Configuración
# ----------------------------

CSV_PATH = "data/ab_testing_teaching_dataset_chatgpt.csv"
DB_PATH = "data/ab_testing.db"

TABLE_NAME = "experiment"

# ----------------------------
# Load CSV
# ----------------------------

df = pd.read_csv(CSV_PATH)

print("CSV loaded successfully.")
print(df.head())

# ----------------------------
# Create SQLite database
# ----------------------------

conn = sqlite3.connect(DB_PATH)

# ----------------------------
# Write dataframe into SQLite
# ----------------------------

df.to_sql(
    TABLE_NAME,
    conn,
    if_exists="replace",
    index=False
)

conn.close()

print(f"Database created successfully!")
print(f"Table '{TABLE_NAME}' contains {len(df)} rows.")