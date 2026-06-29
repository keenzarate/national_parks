with tours as (
    select *
    from {{ source('raw', 'tours') }}
)

select
    tours.state_code,
    tours.timestamp as loaded_at,
    v:"id"::string as tour_id,
    v:"title"::string as title,
    v:"type"::string as type,
    v:"description"::string as description,
    v:"durationMin"::string as duration_min,
    v:"durationMax"::string as duration_max,
    v:"durationUnit"::string as duration_unit,
    v:"relevanceScore"::float as relevance_score,
    v:"park":"parkCode"::string as park_code,
    v:"activities"::variant as activities,
    v:"topics"::variant as topics,
    v:"tags"::variant as tags,
    v:"images"::variant as images,
    v:"stops"::variant as stops
from tours
