with base as (
    select *
    from {{ ref('base_campgrounds') }}
),

keyed as (
    select
        state_code,
        loaded_at,
        {{ dbt_utils.generate_surrogate_key(['campground_id']) }} as k_campground,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'park_code']) }} as k_park,
        campground_id,
        park_code,
        name,
        description,
        latitude,
        longitude,
        lat_long,
        reservation_info,
        reservation_url,
        regulations_overview,
        regulations_url,
        directions_overview,
        directions_url,
        weather_overview,
        number_of_sites_reservable,
        number_of_sites_first_come_first_serve,
        audio_description,
        is_passport_stamp_location
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_campground',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
