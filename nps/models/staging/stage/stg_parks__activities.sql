with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        base.loaded_at,
        activity.value:"id"::string as activity_id,
        activity.value:"name"::string as activity_name
    from base,
    lateral flatten(input => base.activities) as activity
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='flattened',
            partition_by='k_park, activity_id',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
