with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        hours.value:"description"::string as description,
        hours.value:"standardHours"::variant as standard_hours,
        hours.value:"name"::string as name,
        hours.value:"exceptions"::variant as exceptions
    from base,
    lateral flatten(input => base.operating_hours) as hours
)

select * from flattened
