{{ config(materialized='view') }}

with base as (
    select *
    from {{ ref('stg_parks') }}
),

phones as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        phone.value:"type"::string as phone_type,
        phone.value:"phoneNumber"::string as phone_number,
        phone.value:"description"::string as phone_description,
        phone.value:"extension"::string as phone_extension
    from base,
    lateral flatten(input => base.contacts:phoneNumbers) as phone
)

select * from phones
