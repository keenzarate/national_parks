with campgrounds as (
    select *
    from {{ source('raw', 'campgrounds') }}
)

select
    v:"id"::string as campground_id,
    v:"name"::string as name,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"description"::string as description,
    v:"campsites"::variant as campsites,
    v:"amenities"::variant as amenities,
    v:"accessibility"::variant as accessibility,
    v:"fees"::variant as fees,
    v:"operatingHours"::variant as operating_hours,
    v:"relatedParks"::variant as related_parks,
    v:"directionsOverview"::string as directions_overview,
    v:"directionsUrl"::string as directions_url,
    v:"reservationUrl"::string as reservation_url,
    v:"regulationsOverview"::string as regulations_overview,
    v:"regulationsUrl"::string as regulations_url
from campgrounds
