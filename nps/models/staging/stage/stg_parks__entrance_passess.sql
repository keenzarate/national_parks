with base as (
    select *
    from {{ ref('base_parks') }}
),

flattened as (
    select
        base.park_id,
        pass.value:"cost"::string as cost,
        pass.value:"description"::string as description,
        pass.value:"title"::string as title
    from base,
    lateral flatten(input => entrance_passes) as pass
)

select * from flattened
