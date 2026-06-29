with stg as (
    select *
    from {{ ref('stg_parks__activities') }}
)

select
    k_park,
    activity_id,
    activity_name
from stg
