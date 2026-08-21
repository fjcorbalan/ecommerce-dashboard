
from pathlib import Path
from src.database import run_query


query_path = Path("sql/kpis.sql")

query = query_path.read_text(encoding="utf-8")

df = run_query(query)

print(df.head(50))