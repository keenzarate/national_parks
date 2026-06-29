with stg as (
    select *
    from {{ ref('stg_tours') }}
)

select
    stg.k_tour,
    stg.k_park,
    stg.title,
    stg.type,
    stg.description,
    stg.duration_min,
    stg.duration_max,
    stg.duration_unit,
    stg.relevance_score,
    stg.activities,
    stg.topics,
    stg.tags,
    stg.images,
    stg.stops
from stg
