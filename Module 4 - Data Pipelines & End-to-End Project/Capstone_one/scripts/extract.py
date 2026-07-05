import json
from pathlib import Path

import pandas as pd
import requests


API_URL = "https://fakestoreapi.com/products"

RAW_DATA_DIR = Path("data/raw")
RAW_DATA_DIR.mkdir(parents=True, exist_ok=True)


def extract_products():
    """
    Extract product data from the Fake Store API.
    """

    print("Fetching data from Fake Store API...")

    response = requests.get(API_URL, timeout=30)
    response.raise_for_status()

    products = response.json()

    print(f"Retrieved {len(products)} products.")

    return products


def save_json(products):
    json_path = RAW_DATA_DIR / "products.json"

    with open(json_path, "w", encoding="utf-8") as file:
        json.dump(products, file, indent=4)

    print(f"JSON saved to {json_path}")


def save_csv(products):
    csv_path = RAW_DATA_DIR / "products.csv"

    df = pd.json_normalize(products)

    df.to_csv(csv_path, index=False)

    print(f"CSV saved to {csv_path}")


def main():
    products = extract_products()

    save_json(products)
    save_csv(products)

    print("Extraction completed successfully.")


if __name__ == "__main__":
    main()