with places as (
    select *
    from {{ source('raw', 'places') }}
)

select
    places.state_code,
    v:"id"::string as place_id,
    v:"title"::string as title,
    v:"listingDescription"::string as listing_description,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"location"::string as location,
    v:"activities"::variant as activities,
    v:"relatedParks"::variant as related_parks,
    v:"images"::variant as images,
    v:"url"::string as url
from places
