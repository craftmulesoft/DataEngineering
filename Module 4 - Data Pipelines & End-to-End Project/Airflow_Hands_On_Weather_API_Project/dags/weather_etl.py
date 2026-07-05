from airflow import DAG
from airflow.operators.python import PythonOperator

from datetime import datetime

import sys

sys.path.append("/opt/airflow/scripts")

from extract import extract_weather
from transform import transform
from load import load


def etl():

    raw = extract_weather()

    transformed = transform(raw)

    load(transformed)


with DAG(

    dag_id="weather_pipeline",

    start_date=datetime(2025,1,1),

    schedule="@hourly",

    catchup=False

) as dag:

    task = PythonOperator(

        task_id="weather_etl",

        python_callable=etl

    )