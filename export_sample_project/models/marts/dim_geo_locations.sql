with source as (
    select * from {{ ref('stg_geo_locations') }}
),
final as (
    select
        md5(cast(coalesce(cast(city as varchar), '') || '-' || coalesce(cast(state_code as varchar), '') || '-' || coalesce(cast(country_code as varchar), '') as varchar)) as geo_location_key,
        country_code || '-' || state_code || '-' || upper(replace(city, ' ', '_')) as geo_location_id,
        city,
        state_name as state_province,
        state_code,
        country_name as country,
        country_code,
        region,
        country_name as geo_hierarchy_level_1,
        state_name as geo_hierarchy_level_2,
        city as geo_hierarchy_level_3
    from source
)
select * from final