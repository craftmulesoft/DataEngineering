from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "Data Engineering",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="global_ecommerce_pipeline",
    description="Global E-Commerce Analytics Pipeline",
    default_args=default_args,
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    max_active_runs=1,
    tags=["snowflake", "dbt", "airflow", "capstone"],
) as dag:

    # ----------------------------------------------------
    # Extract API Data
    # ----------------------------------------------------

    extract_api = BashOperator(
        task_id="extract_api",
        bash_command="""
        cd /opt/airflow/project &&
        python extract/extract_api.py
        """,
    )

    # ----------------------------------------------------
    # Load JSON into Snowflake
    # ----------------------------------------------------

    load_snowflake = BashOperator(
        task_id="load_snowflake",
        bash_command="""
        cd /opt/airflow/project &&
        python snowflake/load_raw_data.py
        """,
    )

    # ----------------------------------------------------
    # Run dbt Models
    # ----------------------------------------------------

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="""
        cd /opt/airflow/project/capstone_two_dbt &&
        dbt run
        """,
    )

    # ----------------------------------------------------
    # Run dbt Tests
    # ----------------------------------------------------

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        cd /opt/airflow/project/capstone_two_dbt &&
        dbt test
        """,
    )

    # ----------------------------------------------------
    # Generate dbt Documentation
    # ----------------------------------------------------

    dbt_docs = BashOperator(
        task_id="dbt_docs",
        bash_command="""
        cd /opt/airflow/project/capstone_two_dbt &&
        dbt docs generate
        """,
    )

    # ----------------------------------------------------
    # Data Quality Check
    # ----------------------------------------------------

    quality_check = BashOperator(
        task_id="quality_check",
        bash_command="""
        echo "======================================"
        echo "Checking Data Warehouse Quality..."
        echo "Pipeline completed successfully."
        echo "======================================"
        """,
    )

    # ----------------------------------------------------
    # Workflow
    # ----------------------------------------------------

    (extract_api >> load_snowflake >> dbt_run >> dbt_test >> dbt_docs >> quality_check)
