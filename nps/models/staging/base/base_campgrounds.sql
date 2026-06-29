with campgrounds as (
    select *
    from {{ source('raw', 'campgrounds') }}
)
select
    state_code,
    campgrounds.timestamp as loaded_at,
    v:"id"::string as campground_id,
    v:"name"::string as name,
    v:"parkCode"::string as park_code,
    v:"description"::string as description,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"latLong"::string as lat_long,
    v:"audioDescription"::string as audio_description,
    v:"isPassportStampLocation"::string as is_passport_stamp_location,
    v:"passportStampLocationDescription"::string as passport_stamp_location_description,
    v:"geometryPoiId"::string as geometry_poi_id,
    v:"reservationInfo"::string as reservation_info,
    v:"reservationUrl"::string as reservation_url,
    v:"regulationsurl"::string as regulations_url,
    v:"regulationsOverview"::string as regulations_overview,
    v:"directionsOverview"::string as directions_overview,
    v:"directionsUrl"::string as directions_url,
    v:"weatherOverview"::string as weather_overview,
    v:"numberOfSitesReservable"::string as number_of_sites_reservable,
    v:"numberOfSitesFirstComeFirstServe"::string as number_of_sites_first_come_first_serve,
    v:"lastIndexedDate"::string as last_indexed_date,
    v:"relevanceScore"::float as relevance_score,
    -- nested objects / arrays kept as variant (flatten later in child stage models if needed)
    v:"campsites"::variant as campsites,
    v:"amenities"::variant as amenities,
    v:"accessibility"::variant as accessibility,
    v:"fees"::variant as fees,
    v:"addresses"::variant as addresses,
    v:"contacts"::variant as contacts,
    v:"operatingHours"::variant as operating_hours,
    v:"images"::variant as images,
    v:"multimedia"::variant as multimedia,
    v:"passportStampImages"::variant as passport_stamp_images
from campgrounds