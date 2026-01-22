with base as (
    select *
    from {{ ref('stg_parks') }}
),

topics as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        topic.value:"id"::string as topic_id,
        topic.value:"name"::string as topic_name
    from base,
    lateral flatten(input => base.topics) as topic
)

select * from topics
