with base as (
    select *
    from {{ ref('stg_parks') }}
),

topics as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        base.loaded_at,
        topic.value:"id"::string as topic_id,
        topic.value:"name"::string as topic_name
    from base,
    lateral flatten(input => base.topics) as topic
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='topics',
            partition_by='k_park, topic_id',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
