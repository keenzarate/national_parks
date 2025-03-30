import os
import requests
import time
import json
import logging
from airflow.hooks.base import BaseHook


def pull_nps_data(base_url, endpoint, out_path, state_codes, api_key):
    for state_code in state_codes:
        try:
            url = f"{base_url}/{endpoint}?stateCode={state_code}"
            headers = {"X-Api-Key": api_key}

            logging.info(f"Requesting: {url}")
            response = requests.get(url, headers=headers, timeout=10)
            response.raise_for_status()

            data = response.json().get("data", [])
            if not data:
                logging.warning(f"No data returned for {state_code}")
                continue

            os.makedirs(out_path, exist_ok=True)
            filename = os.path.join(out_path, f"{endpoint}_{state_code}.jsonl")

            with open(filename, 'w') as f:
                for row in data:
                    if row is None:
                        logging.warning("Empty row found")
                        continue
                    f.write(json.dumps(row) + "\n")

            logging.info(f"✅ Wrote {len(data)} records for {state_code} → {filename}")
            time.sleep(1)

        except requests.exceptions.RequestException as req_err:
            logging.error(f"API error for {state_code}: {req_err}")
        except json.JSONDecodeError as json_err:
            logging.error(f"JSON decode error for {state_code}: {json_err}")
        except Exception as e:
            logging.error(f"Unexpected error for {state_code}: {e}")

    return True


def run_extract_task(
    base_url: str,
    endpoint: str,
    out_path_template: str,
    state_codes: list,
    conn_id: str,
    ds_nodash: str
):
    logging.info("Starting run_extract_task")
    try:
        logging.info(f"Params received: base_url={base_url}, endpoints={endpoint}, state_codes={state_codes}, out_path_template={out_path_template}, ds_nodash={ds_nodash}")
        conn = BaseHook.get_connection(conn_id)
        api_key = conn.password
        out_path = os.path.join(out_path_template, ds_nodash, endpoint)

        logging.info(f"Starting extract for {endpoint} to {out_path}")
        result = pull_nps_data(base_url, endpoint, out_path, state_codes, api_key)
        return result

    except Exception as e:
        logging.error(f"❌ Error in run_extract_task: {e}", exc_info=True)
        raise