with stg as (
    select *
    from {{ ref('stg_places') }}
)

select
    k_place,
    place_id,
    title,
    listing_description,
    body_text,
    location_description,
    location,
    latitude,
    longitude,
    lat_long,
    url,
    audio_description,
    credit,
    geometry_poi_id,
    is_managed_by_nps,
    is_open_to_public,
    is_passport_stamp_location,
    passport_stamp_location_description,
    managed_by_org,
    managed_by_url,
    relevance_score,
    amenities,
    images,
    multimedia,
    quick_facts,
    related_organizations,
    tags
from stg
