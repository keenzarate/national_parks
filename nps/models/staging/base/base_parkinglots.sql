with parkinglots as (
    select *
    from {{ source('raw', 'parkinglots') }}
)

select
    parkinglots.state_code,
    parkinglots.timestamp as loaded_at,
    v:"id"::string as parkinglot_id,
    v:"name"::string as name,
    v:"altName"::string as alt_name,
    v:"description"::string as description,
    v:"latitude"::float as latitude,
    v:"longitude"::float as longitude,
    v:"geometryPoiId"::string as geometry_poi_id,
    v:"managedByOrganization"::string as managed_by_organization,
    v:"timeZone"::string as time_zone,
    v:"webcamUrl"::string as webcam_url,
    v:"accessibility"::variant as accessibility,
    v:"contacts"::variant as contacts,
    v:"fees"::variant as fees,
    v:"images"::variant as images,
    v:"liveStatus"::variant as live_status,
    v:"operatingHours"::variant as operating_hours,
    v:"relatedParks"::variant as related_parks
from parkinglots
