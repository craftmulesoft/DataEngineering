import json
from pathlib import Path

import snowflake.connector

from config import SNOWFLAKE_CONFIG

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_PATH = BASE_DIR / "data" / "raw"
print(RAW_PATH)

TABLES = {
    "users": "RAW_USERS",
    "products": "RAW_PRODUCTS",
    "carts": "RAW_CARTS",
    "posts": "RAW_POSTS",
    "comments": "RAW_COMMENTS",
    "quotes": "RAW_QUOTES",
    "recipes": "RAW_RECIPES",
    "categories": "RAW_CATEGORIES",
}

conn = snowflake.connector.connect(**SNOWFLAKE_CONFIG)

cursor = conn.cursor()

for folder, table in TABLES.items():

    files = sorted((RAW_PATH / folder).glob("*.json"))

    if not files:
        continue

    latest = files[-1]

    with open(latest, "r", encoding="utf-8") as f:
        data = json.load(f)

    cursor.execute(f"DELETE FROM {table}")

    cursor.execute(
        f"INSERT INTO {table}(RAW_DATA) SELECT PARSE_JSON(%s)",
        (json.dumps(data),),
    )

    print(f"Loaded {latest.name} -> {table}")

cursor.close()
conn.close()
