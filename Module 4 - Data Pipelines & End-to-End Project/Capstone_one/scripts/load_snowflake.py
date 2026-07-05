import os

import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Read CSV
df = pd.read_csv("data/raw/products.csv")

# Connect to Snowflake
conn = snowflake.connector.connect(
    account=os.getenv("SNOWFLAKE_ACCOUNT"),
    user=os.getenv("SNOWFLAKE_USER"),
    password=os.getenv("SNOWFLAKE_PASSWORD"),
    warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
    database=os.getenv("SNOWFLAKE_DATABASE"),
    schema=os.getenv("SNOWFLAKE_SCHEMA"),
    role=os.getenv("SNOWFLAKE_ROLE"),
)

cursor = conn.cursor()

try:
    print("Connected to Snowflake.")

    # Optional: clear table before loading
    cursor.execute("TRUNCATE TABLE RAW.PRODUCTS")

    insert_sql = """
    INSERT INTO RAW.PRODUCTS
    (
        ID,
        TITLE,
        PRICE,
        DESCRIPTION,
        CATEGORY,
        IMAGE,
        RATING_RATE,
        RATING_COUNT
    )
    VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
    """

    for _, row in df.iterrows():
        cursor.execute(
            insert_sql,
            (
                int(row["id"]),
                row["title"],
                float(row["price"]),
                row["description"],
                row["category"],
                row["image"],
                float(row["rating.rate"]),
                int(row["rating.count"]),
            ),
        )

    conn.commit()

    print(f"Successfully loaded {len(df)} rows.")

finally:
    cursor.close()
    conn.close()
    print("Connection closed.")