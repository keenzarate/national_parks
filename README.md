# Building a Scalable Data Pipeline with Airflow, Snowflake, and DBT for the U.S. National Parks API

# Introduction

I built this project as a portfolio piece to demonstrate how to design and deploy a production-style data pipeline using modern tools and engineering best practices. My goal was to build something that mirrors real-world architecture: containerized, modular, and automatable. The project ingests open data from the U.S. National Parks Service API, transforms it using DBT, and stores it in Snowflake. Everything is orchestrated using Airflow inside Docker containers and deployed to an EC2 instance for long-term operation.

This document is designed for:

1. Data engineers looking to learn orchestration and modeling using public APIs
2. Analysts transitioning to analytics engineering roles
3. Anyone looking for a guided breakdown of building a robust ETL pipeline from scratch

# Getting Started

Here’s what you’ll need to follow along:
- Python 3.9+
- Docker & Docker Compose
- A free Snowflake trial account
- Basic understanding of SQL and Python
- Familiarity with terminal/CLI and Git

Folder Structure

```bash
national_parks/
├── dags/
├── data/
├── docker-compose.yml
├── Dockerfile
├── dbt_project/
│   ├── dbt_project.yml
│   └── models/
│       ├── base/
│       ├── staging/
│       └── marts/
├── config/
│   └── nps_config.yaml
└── plugins/
```

# Step-by-Step Setup Guide

## Step 0.5: Set Up Airflow Connections
Before running your pipeline, make sure you’ve added the following connections in the Airflow UI under Admin > Connections:
- AWS S3
```
Conn Id: aws_default

Conn Type: Amazon Web Services

Login: (your Access Key ID)

Password: (your Secret Access Key)

Extra: { "region_name": "us-east-1" }
```
- NPS API
```
Conn Id: nps_api

Conn Type: HTTP

Host: https://developer.nps.gov/api/v1

Password: (API Key here)

Extra: {}
```
- Snowflake
```
Conn Id: snowflake_default

Conn Type: Snowflake

Account: your_account.region

User: your_username

Password: your_password

Database: nps_warehouse

Warehouse: compute_wh

Schema: raw

Role: your_role
```
[Screenshot placeholder: Airflow Connections list]

## Step 0: Set Up Your AWS S3 Bucket

1. Go to the AWS Console → S3 → Create Bucket
2. Create a bucket (e.g.`nps-pipeline-staging`)
4. Update IAM user or role to have access to upload/download files

**Example IAM Policy:**
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::nps-pipeline-staging",
        "arn:aws:s3:::nps-pipeline-staging/*"
      ]
    }
  ]
}
```
🖼️ [Screenshot placeholder: S3 bucket in AWS Console]

Add connection to Airflow.

🖼️ [Screenshot placeholder: Airflow S3 connection setup]
## Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/national_parks.git
cd national_parks
```

## Step 2: Create Your .env File
This file contains environment-specific configs (e.g., API keys, connection IDs).
```bash
touch .env
```
# Add AIRFLOW_UID and any other secrets you want to parameterize

## Step 3: Set Up Docker and Airflow
Start Airflow with Docker Compose:
``` bash
docker-compose up airflow-init
```
Then launch the full environment:
```bash
docker-compose up
```
🖼️ [Screenshot placeholder: Airflow UI running locally]

## Step 4: Verify Volume Mounts
Check that folders like `dags/`, `logs/`, and `data/` are correctly mounted inside the container:
```bash
volumes:
  - ${AIRFLOW_PROJ_DIR:-.}/dags:/opt/airflow/dags
  - ${AIRFLOW_PROJ_DIR:-.}/logs:/opt/airflow/logs
  - ${AIRFLOW_PROJ_DIR:-.}/data:/opt/airflow/data
```
🖼️ [Screenshot placeholder: Docker logs showing successful sync]

## Step 5: Configure Snowflake in DBT
In `~/.dbt/profiles.yml` add your Snowflake/Databricks/etc connection, I am using Snowflake.
```yml
national_parks:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: your_account.region
      user: your_username
      password: your_password
      role: your_role
      database: nps_warehouse
      warehouse: compute_wh
      schema: raw
      threads: 1
      client_session_keep_alive: False
```
🖼️ [Screenshot placeholder: Example DBT connection test]

## Step 6: Test Locally
Manually trigger your DAG in the Airflow UI and check:

1. Logs are created
2. Files land in S3
3. Snowflake receives records
4. DBT models build successfully

🖼️ [Screenshot placeholder: DAG graph view with green tasks]

## Step 7: (Optional) Move to EC2
Once everything works locally, SSH into your EC2 instance and:

1. Copy your repo
2. Install Docker & Docker Compose (optional)

Rerun the same steps in the cloud
🖼️ [Screenshot placeholder: EC2 terminal with pipeline running]

We'll walk through how each of these components ties together in the sections below.

# Airflow DAG Design

Each state has its own Airflow DAG, and within each DAG, we loop through multiple NPS API endpoints like activities, alerts, campgrounds, etc. This dynamic structure keeps the pipeline modular and scalable.

DAG Structure per State:
```
nps_pipeline_dag_<state>
├── extract_<endpoint>
├── upload_to_s3_<endpoint>
├── copy_from_s3_to_snowflake_<endpoint>
└── cleanup_local_files_<endpoint>
```
## Key Features:

- DAGs are dynamically generated per state using Python for-loop logic.
- Each endpoint goes through a 4-step process: extract → upload → load → cleanup.

🖼️ [Screenshot placeholder: Airflow DAG graph view for one state]

## Task Roles:

1. `extract`: Uses PythonOperator to hit the NPS API and store the response in a local JSONL file
2. `upload_to_s3`: Pushes JSONL files to S3 using the S3Hook
3. `copy_from_s3_to_snowflake`: Uses SnowflakeOperator to run a `COPY INTO` query
4. `cleanup_local_files`: Removes the local temp files after load

## DAG Triggering:

All DAGs are triggered manually or on a schedule (e.g., daily)

A future `dbt_dag` is set to run only after all DAGs complete, ensuring raw data is available for transformation

🖼️ [Screenshot placeholder: example Airflow code for dynamic DAG loop]

# Snowflake Table Setup & COPY Logic

After data is uploaded to S3, it’s copied into Snowflake using the `SnowflakeOperator`. Each table in Snowflake is designed to store the raw response (v).

### Table Schema

All raw tables follow this structure:

```sql
CREATE TABLE nps_warehouse.raw.activities (
    state_code VARCHAR,
    v VARIANT,
    timestamp TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP,
    load_date VARCHAR
);
```
Each Airflow task uses a templated SQL string like this:
```sql 
-- Delete old records for this state + date
DELETE FROM activities
WHERE load_date = '20250330' AND state_code = 'az';

-- Load new records from S3
COPY INTO activities (
    state_code,
    v,
    timestamp,
    load_date
)
FROM (
    SELECT 'az', $1, CURRENT_TIMESTAMP(), '20250330'
    FROM @RAW/nps_data/raw/20250330/activities
)
FILE_FORMAT = (TYPE = 'JSON')
PATTERN = '.*\.jsonl';
```

# Considerations

1. The delete step ensures fresh loads per state per day, avoiding duplicates.
2. Using `VARIANT` supports semi-structured JSON for flexibility.
3. A future enhancement could detect changes and skip load if data is identical.

🖼️ [Screenshot placeholder: Snowflake table preview with JSON data]

# DBT Project Structure

With raw data loaded into Snowflake, DBT takes over the transformation step.

Project Layers
```bash
models/
├── base/
│   └── base_activities.sql
├── staging/
│   └── stg_activities.sql
└── marts/
    ├── dim/
    └── fct/
```
1. Base Models

Base models flatten the raw JSON into columns:
``` sql
SELECT
  state_code,
  v:activity_id::STRING AS activity_id,
  v:name::STRING AS name,
  timestamp,
  load_date
FROM {{ source('raw', 'activities') }}
```
2. Staging Models

Staging adds cleaned fields, filters, and primary keys:
``` sql
SELECT *,
  CONCAT_WS('-', state_code, activity_id) AS activity_pk
FROM {{ ref('base_activities') }}
```
3. Marts

In marts/, we join, aggregate, or pivot the cleaned data for analytics or dashboards.

# DBT Testing

We use schema.yml files to define:

    - Column tests (e.g., `not_null`, `unique`)
    - Model descriptions
    - Source declarations

🖼️ [Screenshot placeholder: DBT lineage graph]

# Orchestrating DBT in Airflow

A dedicated `dbt_dag` runs only after all DAGs complete.

Tasks include:
   - dbt run
   - dbt test
   - dbt docs generate

🖼️ [Screenshot placeholder: Airflow UI showing dbt_dag run]

# Issues & Fixes
Below are some issues that I ran into when setting this pipeline up and the relevant fix I made to address the issue

1. DBT Import Errors

Issue: After installing DBT, ModuleNotFoundError and ImportError issues showed up due to dependency mismatches.
Fix: Used a dedicated Python virtual environment and carefully installed DBT with Snowflake adapter.

2. DAGs Not Showing in Airflow

Issue: DAGs weren’t visible in the UI.
Fix: Corrected volume mount paths in docker-compose.yml to properly sync project folders.

3. Snowflake Connection Failure

Issue: Initial Snowflake setup failed with backend connection errors.
Fix: Created a brand-new Snowflake account, ensuring clean setup and permissions.

4. Volume Sync Issues

Issue: DAGs and logs weren’t syncing due to Docker misconfig.
Fix: Updated volume section:
```
volumes:
  - ${AIRFLOW_PROJ_DIR:-.}/dags:/opt/airflow/dags
  - ${AIRFLOW_PROJ_DIR:-.}/logs:/opt/airflow/logs
  - ${AIRFLOW_PROJ_DIR:-.}/data:/opt/airflow/data
```
5. DBT Project Misplaced

Issue: Ran dbt init outside of the intended folder.
Fix: Reinitialized inside the project directory and updated `dbt_project.yml` path.

📸 Final Output and Screenshots

🖼️ [Airflow UI DAG graph showing extract → load → transform]
🖼️ [S3 bucket structure with JSONL files]
🖼️ [Snowflake table preview: raw + staged]
🖼️ [DBT docs lineage graph]
🖼️ [Terminal view of EC2 instance running pipeline]

# Reflections & Key Takeaways

This project gave me the chance to:

1. Build modular, reusable ETL pipelines using Airflow and Python
2. Use DBT for layered modeling and robust testing
3. Orchestrate pipelines across Docker and EC2
4. Practice debugging, system setup, and working with real-world APIs

It’s a great starting point for data engineers, analysts, and developers looking to create end-to-end pipelines that are actually deployable in production.

Let me know if you’d like help replicating or expanding this!

I had a lot of fun working on this project — from building the pipeline logic to debugging the infrastructure and seeing it all run end-to-end. Thanks for reading!

