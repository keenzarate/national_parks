with base as (
    select *
    from {{ ref('stg_parks') }}
),

flattened as (
    select
        base.k_park,
        base.park_id,
        base.park_code,
        img.value:"url"::string as url,
        img.value:"altText"::string as alt_text,
        img.value:"title"::string as title,
        img.value:"caption"::string as caption,
        img.value:"credit"::string as credit
    from base,
    lateral flatten(input => base.images) as img
)

select * from flattened
