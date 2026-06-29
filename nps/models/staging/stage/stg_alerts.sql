with base as (
    select *
    from {{ ref('base_alerts') }}
),

keyed as (
    select
        base.state_code,
        base.loaded_at,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'alert_id']) }} as k_alert,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'park_code']) }} as k_park,
        base.alert_id,
        base.url,
        base.title,
        base.park_code,
        base.description,
        base.category,
        base.last_indexed_date
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_alert',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
