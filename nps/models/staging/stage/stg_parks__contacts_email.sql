with base as (
    select *
    from {{ ref('base_parks') }}
),
emails as (
    select
        base.park_id,
        email.value:"emailAddress"::string as email_address,
        email.value:"description"::string as email_description
    from base,
    lateral flatten(input => contacts:emailAddresses) as email
)

select * from emails
