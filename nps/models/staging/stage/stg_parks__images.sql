with base as (
    select *
    from {{ ref('base_parks') }}
),

flattened as (
    select
        base.park_id,
        img.value:"url"::string as url,
        img.value:"altText"::string as alt_text,
        img.value:"title"::string as title,
        img.value:"caption"::string as caption,
        img.value:"credit"::string as credit
    from base,
    lateral flatten(input => images) as img
)

select * from flattened
