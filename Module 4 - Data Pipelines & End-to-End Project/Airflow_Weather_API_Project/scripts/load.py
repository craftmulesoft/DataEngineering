from database import get_connection


def load(data):

    conn = get_connection()

    cur = conn.cursor()

    sql = """
    INSERT INTO weather_data
    (
    city,
    temperature,
    windspeed,
    winddirection,
    weathercode,
    observation_time
    )
    VALUES
    (%s,%s,%s,%s,%s,%s)
    """

    cur.execute(sql, (

        data["city"],

        data["temperature"],

        data["windspeed"],

        data["winddirection"],

        data["weathercode"],

        data["observation_time"]

    ))

    conn.commit()

    cur.close()

    conn.close()