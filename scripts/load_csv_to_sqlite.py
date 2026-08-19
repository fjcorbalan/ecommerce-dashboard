import sqlite3
import pandas as pd


# --------------------------------
# Configuration
# --------------------------------

DB_PATH = "data/ecommerce.db"


FILES = {
    "customers": "data/olist_customers_dataset.csv",
    "geolocation": "data/olist_geolocation_dataset.csv",
    "order_items": "data/olist_order_items_dataset.csv",
    "order_payments": "data/olist_order_payments_dataset.csv",
    "orders": "data/olist_orders_dataset.csv",
    "products": "data/olist_products_dataset.csv"
}


# --------------------------------
# Create SQLite database
# --------------------------------

conn = sqlite3.connect(DB_PATH)


# --------------------------------
# Load CSV files into SQLite
# --------------------------------

for table_name, csv_path in FILES.items():

    print(f"Loading {table_name}...")

    df = pd.read_csv(csv_path)

    df.to_sql(
        table_name,
        conn,
        if_exists="replace",
        index=False
    )

    print(f"{table_name}: {len(df):,} rows loaded.")


# --------------------------------
# Close connection
# --------------------------------

conn.close()

print("\nSQLite warehouse created successfully.")