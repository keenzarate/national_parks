with stg as (
    select *
    from {{ ref('stg_parks__topics') }}
)

select
    k_park,
    topic_id,
    topic_name
from stg
