select
    k_park,
    k_things_to_do
from {{ ref('stg_thingstodo__related_parks') }}
