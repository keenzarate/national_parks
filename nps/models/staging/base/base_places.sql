with places as (
    select *
    from {{ source('raw', 'places') }}
)

select
    places.state_code,
    places.timestamp as loaded_at,
    v:"id"::string as place_id,
    v:"title"::string as title,
    v:"listingDescription"::string as listing_description,
    v:"bodyText"::string as body_text,
    v:"locationDescription"::string as location_description,
    v:"location"::string as location,
    v:"latitude"::string as latitude,
    v:"longitude"::string as longitude,
    v:"latLong"::string as lat_long,
    v:"url"::string as url,
    v:"audioDescription"::string as audio_description,
    v:"credit"::string as credit,
    v:"associatedIcon"::string as associated_icon,
    v:"geometryPoiId"::string as geometry_poi_id,
    v:"npmapId"::string as npmap_id,
    v:"isManagedByNps"::string as is_managed_by_nps,
    v:"isMapPinHidden"::string as is_map_pin_hidden,
    v:"isOpenToPublic"::string as is_open_to_public,
    v:"isPassportStampLocation"::string as is_passport_stamp_location,
    v:"passportStampLocationDescription"::string as passport_stamp_location_description,
    v:"managedByOrg"::string as managed_by_org,
    v:"managedByUrl"::string as managed_by_url,
    v:"relevanceScore"::float as relevance_score,
    v:"amenities"::variant as amenities,
    v:"images"::variant as images,
    v:"multimedia"::variant as multimedia,
    v:"passportStampImages"::variant as passport_stamp_images,
    v:"quickFacts"::variant as quick_facts,
    v:"relatedOrganizations"::variant as related_organizations,
    v:"relatedParks"::variant as related_parks,
    v:"tags"::variant as tags
from places
