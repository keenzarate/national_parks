import os
import logging
import shutil
from airflow.providers.amazon.aws.hooks.s3 import S3Hook


def upload_files_to_s3(
    local_base_path: str,
    s3_folder_prefix: str,
    s3_bucket: str,        
    s3_conn_id: str,
    endpoint:str,
    ds_nodash: str
):
    """
    Upload JSONL files from a local date-partitioned folder to an S3 folder prefix,
    also appended with ds_nodash. 
    """

    # Local date-partitioned path, e.g. "/opt/airflow/data/nps/20250330"
    local_path = os.path.join(local_base_path, ds_nodash, endpoint)

    # Construct final S3 prefix, e.g. "nps_data/raw/20250330"
    s3_folder_path = os.path.join(s3_folder_prefix, ds_nodash, endpoint)

    # Initialize the S3 hook with the given AWS connection
    s3_hook = S3Hook(aws_conn_id=s3_conn_id)

    # Check if local folder exists
    if not os.path.exists(local_path):
        logging.warning(f"[S3 Upload] No files to upload in {local_path}")
        return

    # Loop over JSONL files in the local folder
    for filename in os.listdir(local_path):
        full_path = os.path.join(local_path, filename)
        if os.path.isfile(full_path) and filename.endswith(".jsonl"):
            # Build final S3 object key: "nps_data/raw/20250330/parks_ca.jsonl"
            s3_key = os.path.join(s3_folder_path, filename)

            try:
                s3_hook.load_file(
                    filename=full_path,
                    key=s3_key,
                    bucket_name=s3_bucket,
                    replace=True
                )
                logging.info(f"✅ Uploaded: {filename} → s3://{s3_bucket}/{s3_key}")
            except Exception as e:
                logging.error(f"❌ Failed to upload {filename}: {e}")


def get_copy_sql(
    s3_folder_prefix: str,
    file_pattern: str,
    table_name: str,
    stage_name: str,
    ds_nodash: str,
    state_code: str
) -> str:
    return f"""
    -- Delete old records for this state and date
    DELETE FROM {table_name.upper()}
    WHERE load_date = '{ds_nodash}' AND state_code = '{state_code}';

    -- Load new data
    COPY INTO {table_name.upper()} (
        state_code,
        v,
        timestamp,
        load_date
    )
    FROM (
        SELECT '{state_code}', $1, CURRENT_TIMESTAMP(), '{ds_nodash}'
        FROM @{stage_name}/{s3_folder_prefix}
    )
    FILE_FORMAT = (TYPE = 'JSON')
    PATTERN = '{file_pattern}';
    """



def cleanup_local_files(
    local_base_path: str,
    ds_nodash: str,
    endpoint:str
):
    local_path = os.path.join(local_base_path, ds_nodash, endpoint)
    if os.path.exists(local_path):
        try:
            shutil.rmtree(local_path)
            logging.info(f"Deleted local files at: {local_path}")
        except Exception as e:
            logging.error(f"❌ Cleanup failed: {e}")
    else:
        logging.warning(f"[Cleanup] Nothing to delete at: {local_path}")
