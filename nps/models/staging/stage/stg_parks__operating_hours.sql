with base as (
    select *
    from {{ ref('base_parks') }}
),

flattened as (
    select
        base.park_id,
        hours.value:"description"::string as description,
        hours.value:"standardHours"::variant as standard_hours,
        hours.value:"name"::string as name,
        hours.value:"exceptions"::variant as exceptions
    from base,
    lateral flatten(input => operating_hours) as hours
)

select * from flattened
