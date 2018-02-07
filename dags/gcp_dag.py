from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.contrib.operators.bigquery_operator import BigQueryOperator
from airflow.contrib.operators.bigquery_to_gcs import BigQueryToCloudStorageOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2018, 1, 10),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

PROJECT_ID = 'gcp-rocco'
CONNECTION_ID = 'google_cloud_connection'
BQ_DATASET_NAME = 'github_licenses'
BQ_TABLE_NAME = 'license'
GCS_BUCKET_ID = 'gcp-rocco'

with DAG('gcp_dag', schedule_interval=timedelta(days=1), default_args=default_args) as dag:
    table_name = PROJECT_ID + '.' + BQ_DATASET_NAME + '.' + BQ_TABLE_NAME
    gcs_export_uri = 'gs://' + GCS_BUCKET_ID + '/daily_exports/part-*.gz'

    # Compute data
    bq_compute_data = BigQueryOperator(
        task_id = 'bq_compute_data',
        bql = 'gcp_dag/query_template.sql',
        destination_dataset_table = table_name,
        write_disposition = 'WRITE_TRUNCATE',
        bigquery_conn_id = CONNECTION_ID,
        use_legacy_sql = False
    )

    # Export to Storage
    export_to_storage = BigQueryToCloudStorageOperator(
        task_id = 'export_to_storage',
        source_project_dataset_table = table_name,
        destination_cloud_storage_uris = [
            gcs_export_uri
        ],
        export_format = 'NEWLINE_DELIMITED_JSON',
        compression = 'GZIP',
        bigquery_conn_id = CONNECTION_ID,
    )

    bq_compute_data >> export_to_storage
