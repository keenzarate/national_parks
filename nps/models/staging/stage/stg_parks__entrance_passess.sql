with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        pass.value:"cost"::string as cost,
        pass.value:"description"::string as description,
        pass.value:"title"::string as title
    from base,
    lateral flatten(input => base.entrance_passes) as pass
)

select * from flattened
