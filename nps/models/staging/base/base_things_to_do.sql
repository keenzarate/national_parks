with thingstodo as (
    select *
    from {{ source('raw', 'things_to_do') }}
)

select
    v:"id"::string as thing_id,
    v:"title"::string as title,
    v:"shortDescription"::string as short_description,
    v:"longDescription"::string as long_description,
    v:"activities"::variant as activities,
    v:"relatedParks"::variant as related_parks,
    v:"duration"::string as duration,
    v:"durationUnit"::string as duration_unit,
    v:"images"::variant as images,
    v:"url"::string as url
from thingstodo
