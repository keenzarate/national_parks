with base as (
    select *
    from {{ ref('stg_parks') }}
),
emails as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        email.value:"emailAddress"::string as email_address,
        email.value:"description"::string as email_description
    from base,
    lateral flatten(input => base.contacts:emailAddresses) as email
)

select * from emails
