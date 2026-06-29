with base as (
    select *
    from {{ ref('base_parkinglots') }}
),

keyed as (
    select
        {{ dbt_utils.generate_surrogate_key(['state_code', 'parkinglot_id']) }} as k_parkinglot,
        base.state_code,
        base.loaded_at,
        base.parkinglot_id,
        base.name,
        base.alt_name,
        base.description,
        base.latitude,
        base.longitude,
        base.geometry_poi_id,
        base.managed_by_organization,
        base.time_zone,
        base.webcam_url,
        base.accessibility,
        base.contacts,
        base.fees,
        base.images,
        base.live_status,
        base.operating_hours,
        base.related_parks
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_parkinglot',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
