with source as (

    select * from {{ ref('raw_geo_locations') }}

),

standardized as (

    select
        initcap(trim(city)) as city,
        upper(trim(state_code)) as state_code,
        initcap(trim(state_name)) as state_name,
        upper(trim(country_code)) as country_code,
        initcap(trim(country_name)) as country_name,
        initcap(trim(region)) as region

    from source
    where city is not null
      and state_code is not null

),

deduplicated as (

    select distinct
        city,
        state_code,
        state_name,
        country_code,
        country_name,
        region

    from standardized

)

select * from deduplicated
