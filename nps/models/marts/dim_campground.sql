with stg as (
    select *
    from {{ ref('stg_campgrounds') }}
)

select
    stg.k_campground,
    stg.k_park,
    stg.campground_id,
    stg.name,
    stg.description,
    stg.latitude,
    stg.longitude,
    stg.lat_long,
    stg.reservation_info,
    stg.reservation_url,
    stg.regulations_overview,
    stg.regulations_url,
    stg.directions_overview,
    stg.directions_url,
    stg.weather_overview,
    stg.number_of_sites_reservable,
    stg.number_of_sites_first_come_first_serve,
    stg.audio_description,
    stg.is_passport_stamp_location
from stg
