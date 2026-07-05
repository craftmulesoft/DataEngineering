FROM apache/airflow:2.11.0-python3.12

USER root

RUN apt-get update && \
    apt-get install -y git gcc g++ && \
    apt-get clean

USER airflow

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt