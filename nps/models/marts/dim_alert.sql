with stg as (
    select *
    from {{ ref('stg_alerts') }}
)

select
    stg.k_alert,
    stg.k_park,
    stg.url,
    stg.title,
    stg.category,
    stg.description,
    stg.last_indexed_date
from stg
