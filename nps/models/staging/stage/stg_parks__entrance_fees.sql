with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        fee.value:"cost"::string as cost,
        fee.value:"description"::string as description,
        fee.value:"title"::string as title
    from base,
    lateral flatten(input => base.entrance_fees) as fee
)
select * from flattened
