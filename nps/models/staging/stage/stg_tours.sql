with base as (
    select *
    from {{ ref('base_tours') }}
),

keyed as (
    select
        {{ dbt_utils.generate_surrogate_key(['state_code', 'tour_id']) }} as k_tour,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'park_code']) }} as k_park,
        base.state_code,
        base.loaded_at,
        base.tour_id,
        base.park_code,
        base.title,
        base.type,
        base.description,
        base.duration_min,
        base.duration_max,
        base.duration_unit,
        base.relevance_score,
        base.activities,
        base.topics,
        base.tags,
        base.images,
        base.stops
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_tour',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
