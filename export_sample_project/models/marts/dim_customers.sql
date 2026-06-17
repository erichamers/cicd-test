with source as (

    select * from {{ ref('stg_customers') }}

),

geo_locations as (

    select * from {{ ref('dim_geo_locations') }}

),

final as (

    select
        md5(cast(coalesce(cast(c.customer_id as varchar), '') as varchar)) as customer_key,
        c.customer_id,
        c.customer_name,
        c.customer_type,
        c.address_line_1,
        c.city,
        c.state,
        c.zip_code,
        c.region,
        c.dea_number,
        c.is_active,
        g.geo_location_key

    from source c
    left join geo_locations g
        on initcap(trim(c.city)) = g.city
        and upper(trim(c.state)) = g.state_code

)

select * from final