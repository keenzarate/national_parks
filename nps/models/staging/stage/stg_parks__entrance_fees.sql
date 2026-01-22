with base as (
    select *
    from {{ ref('base_parks') }}
),

flattened as (
    select
        base.park_id,
        fee.value:"cost"::string as cost,
        fee.value:"description"::string as description,
        fee.value:"title"::string as title
    from base,
    lateral flatten(input => entrance_fees) as fee
)
select * from flattened
