with parks as (
    select *
    from {{ source('raw', 'parks') }}
)
select
    state_code,
    v:"id"::string as park_id,
    v:"parkCode"::string as park_code,
    v:"name"::string as name,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"latLong"::string as lat_long,
    v:"states"::string as states,
    v:"designation"::string as designation,
    v:"directionsInfo"::string as directions_info,
    v:"directionsUrl"::string as directions_url,
    v:"weatherInfo"::string as weather_info,
    v:"url"::string as url,
    v:"fullName"::string as full_name,
    v:"parkType"::string as park_type,
    v:"activities" as activities,
    v:"topics" as topics,
    v:"addresses" as addresses,
    v:"entranceFees" as entrance_fees,
    v:"entrancePasses" as entrance_passes,
    v:"operatingHours" as operating_hours,
    v:"images" as images,
    v:"contacts" as contacts,
    v:"amenities"::string as amenities,
    v:"visitorCenters"::string as visitor_centers,
    v:"campgrounds"::string as campgrounds
from parks