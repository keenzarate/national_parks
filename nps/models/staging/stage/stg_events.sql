with base as (
    select *
    from {{ ref('base_events') }}
),

keyed as (
    select
        {{ dbt_utils.generate_surrogate_key(['state_code', 'event_id']) }} as k_event,
        {{ dbt_utils.generate_surrogate_key(['state_code', 'park_code']) }} as k_park,
        base.state_code,
        base.loaded_at,
        base.event_id,
        base.event_legacy_id,
        base.park_code,
        base.site_type,
        base.title,
        base.park_full_name,
        base.description,
        base.category,
        base.category_id,
        base.types,
        base.tags,
        base.event_date,
        base.date_start,
        base.date_end,
        base.dates,
        base.time_info,
        base.times,
        base.is_all_day,
        base.is_recurring,
        base.recurrence_rule,
        base.recurrence_date_start,
        base.recurrence_date_end,
        base.is_free,
        base.fee_info,
        base.is_registration_required,
        base.registration_info,
        base.registration_url,
        base.location,
        base.latitude,
        base.longitude,
        base.contact_name,
        base.contact_email_address,
        base.contact_telephone_number,
        base.organization_name,
        base.portal_name,
        base.subject_name,
        base.info_url,
        base.image_id_list,
        base.images,
        base.datetime_created,
        base.datetime_updated
    from base
),

deduped as (
    {{
        dbt_utils.deduplicate(
            relation='keyed',
            partition_by='k_event',
            order_by='loaded_at desc'
        )
    }}
)

select * from deduped
