with stg as (
    select *
    from {{ ref('stg_visitorcenters') }}
)

select
    stg.k_visitorcenter,
    stg.k_park,
    stg.name,
    stg.url,
    stg.description,
    stg.audio_description,
    stg.latitude,
    stg.longitude,
    stg.lat_long,
    stg.directions_info,
    stg.directions_url,
    stg.geometry_poi_id,
    stg.is_passport_stamp_location,
    stg.passport_stamp_location_description,
    stg.last_indexed_date,
    stg.relevance_score,
    stg.amenities,
    stg.operating_hours,
    stg.addresses,
    stg.contacts,
    stg.images,
    stg.multimedia,
    stg.passport_stamp_images
from stg
