with stg as (
    select *
    from {{ ref('stg_thingstodo') }}
)

select
    k_things_to_do,
    state_code,
    thing_id,
    title,
    short_description,
    long_description,
    location,
    location_description,
    latitude,
    longitude,
    url,
    credit,
    geometry_poi_id,
    accessibility_information,
    age,
    age_description,
    activity_description,
    duration,
    duration_description,
    season,
    season_description,
    time_of_day,
    time_of_day_description,
    do_fees_apply,
    fee_description,
    is_reservation_required,
    reservation_description,
    are_pets_permitted,
    are_pets_permitted_with_restrictions,
    pets_description,
    relevance_score,
    activities,
    topics,
    amenities,
    images,
    tags,
    related_organizations
from stg
