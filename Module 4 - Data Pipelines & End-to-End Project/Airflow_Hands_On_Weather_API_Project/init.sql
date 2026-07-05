CREATE TABLE IF NOT EXISTS weather_data(

id SERIAL PRIMARY KEY,

city VARCHAR(100),

temperature DOUBLE PRECISION,

windspeed DOUBLE PRECISION,

winddirection DOUBLE PRECISION,

weathercode INTEGER,

observation_time TIMESTAMP

);