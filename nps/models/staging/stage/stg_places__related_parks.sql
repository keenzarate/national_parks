with stg as (
    select *
    from {{ ref('stg_places') }}
),

flattened as (
    select
        stg.k_place,
        related.value:"parkCode"::string as park_code
    from stg,
    lateral flatten(input => stg.related_parks) as related
),

parks as (
    select k_park, park_code
    from {{ ref('stg_parks') }}
)

select distinct
    flattened.k_place,
    parks.k_park,
    flattened.park_code
from flattened
join parks on flattened.park_code = parks.park_code
