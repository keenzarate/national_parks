select
    k_park,
    k_place
from {{ ref('stg_places__related_parks') }}
