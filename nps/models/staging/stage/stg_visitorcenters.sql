with base as (
    select *
    from {{ ref('base_visitorcenters') }}
),

keyed as (
    select
        {{ dbt_utils.generate_surrogate_key(['state_code', 'visitorcenter_id']) }} as k_visitorcenter,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'park_code']) }} as k_park,
        base.state_code,
        base.loaded_at,
        base.visitorcenter_id,
        base.url,
        base.name,
        base.park_code,
        base.description,
        base.audio_description,
        base.latitude,
        base.longitude,
        base.lat_long,
        base.directions_info,
        base.directions_url,
        base.geometry_poi_id,
        base.is_passport_stamp_location,
        base.passport_stamp_location_description,
        base.last_indexed_date,
        base.relevance_score,
        base.amenities,
        base.operating_hours,
        base.addresses,
        base.contacts,
        base.images,
        base.multimedia,
        base.passport_stamp_images
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_visitorcenter',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
