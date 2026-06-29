with stg as (
    select *
    from {{ ref('stg_parks') }}
)

select
    k_park,
    park_id,
    park_code,
    state_code,
    states,
    name,
    full_name,
    description,
    designation,
    latitude,
    longitude,
    lat_long,
    url,
    weather_info,
    directions_info,
    directions_url,
    relevance_score
from stg
