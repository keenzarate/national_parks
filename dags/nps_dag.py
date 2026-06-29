from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from datetime import datetime
from airflow.utils.dates import days_ago
import yaml
import os

from utils.extract_api import run_extract_task
from utils.s3_to_snowflake import upload_files_to_s3, get_copy_sql, cleanup_local_files


def load_config():
    config_path = os.path.join(os.path.dirname(__file__), "config", "nps_config.yaml")
    with open(config_path, "r") as f:
        return yaml.safe_load(f)

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
}


config = load_config()
base_url = config["extract"]["base_url"]
endpoints = config["extract"]["endpoints"]
outpath = config["extract"]["out_path"]
api_conn_id = config["extract"]["api_conn_id"]

s3_folder_prefix = config["upload"]["s3_folder_prefix"]
s3_bucket = config["upload"]["s3_bucket"]
s3_conn_id = config["upload"]["s3_conn_id"]

file_pattern = config["load"]["file_pattern"]
stage_name = config["load"]["stage_name"]
snowflake_conn_id = config["load"]["snowflake_conn_id"]

states = config["extract"]["state_codes"]


for state in states:
    dag = DAG(
        dag_id=f'nps_pipeline_dag_{state}',
        default_args=default_args,
        schedule_interval=None,
        catchup=False,
        tags=['nps', 'api']
    )

    with dag:
        for endpoint in endpoints:
            extract = PythonOperator(
                task_id=f"extract_{endpoint}",
                python_callable=run_extract_task,
                op_kwargs={
                    "base_url": base_url,
                    "endpoint": endpoint,
                    "out_path_template": outpath,
                    "state_codes": [state],  # only pass the current state
                    "conn_id": api_conn_id
                },
                provide_context=True
            )

            upload = PythonOperator(
                task_id=f"upload_to_s3_{endpoint}",
                python_callable=upload_files_to_s3,
                op_kwargs={
                    "local_base_path": outpath,
                    "s3_folder_prefix": s3_folder_prefix,
                    "s3_bucket": s3_bucket,
                    "s3_conn_id": s3_conn_id,
                    "endpoint": endpoint,
                    "ds_nodash": "{{ ds_nodash }}"
                },
                provide_context=True
            )

            load = SnowflakeOperator(
                task_id=f"copy_from_s3_to_snowflake_{endpoint}",
                snowflake_conn_id=snowflake_conn_id,
                sql=get_copy_sql(
                    s3_folder_prefix=f"{s3_folder_prefix}/{{{{ ds_nodash }}}}/{endpoint}",
                    file_pattern=file_pattern,
                    table_name=endpoint,
                    stage_name=stage_name,
                    state_code=state,
                    ds_nodash="{{ ds_nodash }}"
                )
            )

            cleanup = PythonOperator(
                task_id=f"cleanup_local_files_{endpoint}",
                python_callable=cleanup_local_files,
                op_kwargs={
                    "local_base_path": outpath, 
                    "ds_nodash": "{{ ds_nodash }}",
                    "endpoint": endpoint},
                provide_context=True
            )

            extract >> upload >> load >> cleanup

    globals()[f"nps_pipeline_dag_{state}"] = dag