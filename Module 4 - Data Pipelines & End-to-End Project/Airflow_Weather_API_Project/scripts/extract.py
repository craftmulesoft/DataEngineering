import requests


def extract_weather():

    url = (
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=9.03"
        "&longitude=38.74"
        "&current_weather=true"
    )

    response = requests.get(url)

    response.raise_for_status()

    return response.json()