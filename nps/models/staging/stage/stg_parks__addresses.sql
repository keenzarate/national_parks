{{ config(materialized='view') }}

with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        address.value:"type"::string as address_type,
        address.value:"line1"::string as line1,
        address.value:"line2"::string as line2,
        address.value:"line3"::string as line3,
        address.value:"city"::string as city,
        address.value:"stateCode"::string as state,
        address.value:"postalCode"::string as postal_code
    from base,
    lateral flatten(input => base.addresses) as address
)

select * from flattened
