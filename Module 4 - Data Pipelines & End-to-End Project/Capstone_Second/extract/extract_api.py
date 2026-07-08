import json
from datetime import datetime
from pathlib import Path

import requests

BASE_URL = "https://dummyjson.com"

ENDPOINTS = {
    "users": "users",
    "products": "products",
    "carts": "carts",
    "posts": "posts",
    "comments": "comments",
    "quotes": "quotes",
    "recipes": "recipes",
    "categories": "products/categories",
}

RAW_ROOT = Path("data/raw")


def download_endpoint(name, endpoint):
    url = f"{BASE_URL}/{endpoint}"

    print(f"Downloading {name}...")

    response = requests.get(url)
    response.raise_for_status()

    data = response.json()

    endpoint_folder = RAW_ROOT / name
    endpoint_folder.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y_%m_%d_%H%M%S")

    filename = f"{name}_{timestamp}.json"

    filepath = endpoint_folder / filename

    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4)

    print(f"Saved -> {filepath}")


def main():
    for name, endpoint in ENDPOINTS.items():
        download_endpoint(name, endpoint)

    print("\nAll datasets successfully saved.")


if __name__ == "__main__":
    main()
