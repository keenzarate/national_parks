with base as (
    select *
    from {{ ref('base_places') }}
),

keyed as (
    select
        {{ dbt_utils.generate_surrogate_key(['state_code', 'place_id']) }} as k_place,
        base.state_code,
        base.loaded_at,
        base.place_id,
        base.title,
        base.listing_description,
        base.body_text,
        base.location_description,
        base.location,
        base.latitude,
        base.longitude,
        base.lat_long,
        base.url,
        base.audio_description,
        base.credit,
        base.associated_icon,
        base.geometry_poi_id,
        base.npmap_id,
        base.is_managed_by_nps,
        base.is_map_pin_hidden,
        base.is_open_to_public,
        base.is_passport_stamp_location,
        base.passport_stamp_location_description,
        base.managed_by_org,
        base.managed_by_url,
        base.relevance_score,
        base.amenities,
        base.images,
        base.multimedia,
        base.passport_stamp_images,
        base.quick_facts,
        base.related_organizations,
        base.related_parks,
        base.tags
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_place',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
