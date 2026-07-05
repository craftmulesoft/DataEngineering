from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="ecommerce_pipeline",
    description="End-to-End Ecommerce Data Pipeline",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args=default_args,
    tags=["capstone", "snowflake", "dbt"],
) as dag:

    extract_api = BashOperator(
        task_id="extract_api",
        bash_command="""
        cd /opt/airflow/project &&
        python scripts/extract.py
        """
    )

    load_snowflake = BashOperator(
        task_id="load_snowflake",
        bash_command="""
        cd /opt/airflow/project &&
        python scripts/load_snowflake.py
        """
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        cd /opt/airflow/project/dbt_project &&
        python -c "from dotenv import load_dotenv; load_dotenv(); import os; import subprocess; subprocess.run(['dbt', 'run', '--profiles-dir', '.'], env=os.environ.copy())"
        """
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        cd /opt/airflow/project/dbt_project &&
        python -c "from dotenv import load_dotenv; load_dotenv(); import os; import subprocess; subprocess.run(['dbt', 'test', '--profiles-dir', '.'], env=os.environ.copy())"
        """
    )

    extract_api >> load_snowflake >> dbt_run >> dbt_test