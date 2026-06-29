with alerts as (
    select *
    from {{ source('raw', 'alerts') }}
)

select
    alerts.state_code,
    alerts.timestamp as loaded_at,
    v:"id"::string as alert_id,
    v:"url"::string as url,
    v:"title"::string as title,
    v:"parkCode"::string as park_code,
    v:"description"::string as description,
    v:"category"::string as category,
    v:"lastIndexedDate"::string as last_indexed_date
from alerts
