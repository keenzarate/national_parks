{{ config(materialized='view') }}

with base as (
    select *
    from {{ ref('base_parks') }}
),

phones as (
    select
        base.park_id,
        phone.value:"type"::string as phone_type,
        phone.value:"phoneNumber"::string as phone_number,
        phone.value:"description"::string as phone_description,
        phone.value:"extension"::string as phone_extension
    from base,
    lateral flatten(input => contacts:phoneNumbers) as phone
)

select * from phones