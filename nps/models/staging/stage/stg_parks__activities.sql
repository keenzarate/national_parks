with base as (
    select *
    from {{ ref('base_parks') }}
),

flattened as (
    select
        base.park_id,
        activity.value:"id"::string as activity_id,
        activity.value:"name"::string as activity_name
    from base,
    lateral flatten(input => activities) as activity
)

select * from flattened
