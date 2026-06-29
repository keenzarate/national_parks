with visitorcenters as (
    select *
    from {{ source('raw', 'visitorcenters') }}
)

select
    visitorcenters.state_code,
    visitorcenters.timestamp as loaded_at,
    v:"id"::string as visitorcenter_id,
    v:"url"::string as url,
    v:"name"::string as name,
    v:"parkCode"::string as park_code,
    v:"description"::string as description,
    v:"audioDescription"::string as audio_description,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"latLong"::string as lat_long,
    v:"directionsInfo"::string as directions_info,
    v:"directionsUrl"::string as directions_url,
    v:"geometryPoiId"::string as geometry_poi_id,
    v:"isPassportStampLocation"::string as is_passport_stamp_location,
    v:"passportStampLocationDescription"::string as passport_stamp_location_description,
    v:"lastIndexedDate"::string as last_indexed_date,
    v:"relevanceScore"::float as relevance_score,
    v:"amenities"::variant as amenities,
    v:"operatingHours"::variant as operating_hours,
    v:"addresses"::variant as addresses,
    v:"contacts"::variant as contacts,
    v:"images"::variant as images,
    v:"multimedia"::variant as multimedia,
    v:"passportStampImages"::variant as passport_stamp_images
from visitorcenters
