with parks as (
    select *
    from {{ source('raw', 'parks') }}
)
select
    state_code,
    parks.timestamp as loaded_at,
    v:"id"::string as park_id,
    v:"parkCode"::string as park_code,
    v:"name"::string as name,
    v:"fullName"::string as full_name,
    v:"description"::string as description,
    v:"designation"::string as designation,
    v:"states"::string as states,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"latLong"::string as lat_long,
    v:"directionsInfo"::string as directions_info,
    v:"directionsUrl"::string as directions_url,
    v:"weatherInfo"::string as weather_info,
    v:"url"::string as url,
    v:"relevanceScore"::float as relevance_score,
    v:"activities"::variant as activities,
    v:"topics"::variant as topics,
    v:"addresses"::variant as addresses,
    v:"contacts"::variant as contacts,
    v:"entranceFees"::variant as entrance_fees,
    v:"entrancePasses"::variant as entrance_passes,
    v:"fees"::variant as fees,
    v:"operatingHours"::variant as operating_hours,
    v:"images"::variant as images,
    v:"multimedia"::variant as multimedia
from parks
