import sqlite3

conn = sqlite3.connect("data/ecommerce.db")

tables = conn.execute("""
    SELECT name
    FROM sqlite_master
    WHERE type = 'table'
    ORDER BY name;
""").fetchall()

print(tables)

conn.close()