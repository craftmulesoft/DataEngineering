from datetime import datetime


def transform(data):

    weather = data["current_weather"]

    return {

        "city": "Addis Ababa",

        "temperature": weather["temperature"],

        "windspeed": weather["windspeed"],

        "winddirection": weather["winddirection"],

        "weathercode": weather["weathercode"],

        "observation_time": datetime.fromisoformat(
            weather["time"]
        )
    }