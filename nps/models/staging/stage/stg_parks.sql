with base as (
    select *
    from {{ ref('base_parks') }}
)

select
    dbt_utils.surrogate_key([base.state_code, base.park_id]) as k_park,
    base.state_code,
    base.park_id,
    base.park_code,
    base.name,
    base.latitude,
    base.longitude,
    base.lat_long,
    base.states,
    base.designation,
    base.directions_info,
    base.directions_url,
    base.weather_info,
    base.url,
    base.full_name,
    base.park_type,
    base.activities,
    base.topics,
    base.addresses,
    base.entrance_fees,
    base.entrance_passes,
    base.operating_hours,
    base.images,
    base.contacts,
    base.amenities,
    base.visitor_centers,
    base.campgrounds
from base