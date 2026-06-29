with base as (
    select *
    from {{ ref('base_things_to_do') }}
),

keyed as (
    select
        base.state_code,
        base.loaded_at,
        {{ dbt_utils.generate_surrogate_key(['thing_id']) }} as k_things_to_do,
        base.thing_id,
        base.title,
        base.short_description,
        base.long_description,
        base.location,
        base.location_description,
        base.latitude,
        base.longitude,
        base.url,
        base.credit,
        base.geometry_poi_id,
        base.accessibility_information,
        base.age,
        base.age_description,
        base.activity_description,
        base.duration,
        base.duration_description,
        base.season,
        base.season_description,
        base.time_of_day,
        base.time_of_day_description,
        base.do_fees_apply,
        base.fee_description,
        base.is_reservation_required,
        base.reservation_description,
        base.are_pets_permitted,
        base.are_pets_permitted_with_restrictions,
        base.pets_description,
        base.relevance_score,
        base.activities,
        base.topics,
        base.amenities,
        base.images,
        base.tags,
        base.related_organizations,
        base.related_parks
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_things_to_do',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
