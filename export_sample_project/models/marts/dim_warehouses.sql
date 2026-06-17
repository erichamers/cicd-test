with source as (

    select * from {{ ref('stg_warehouses') }}

),

geo_locations as (

    select * from {{ ref('dim_geo_locations') }}

),

final as (

    select
        md5(cast(coalesce(cast(w.warehouse_id as varchar), '') as varchar)) as warehouse_key,
        w.warehouse_id,
        w.warehouse_name,
        w.city,
        w.state,
        w.capacity_units,
        case
            when w.capacity_units >= 50000 then 'Large'
            when w.capacity_units >= 40000 then 'Medium'
            else 'Small'
        end as capacity_tier,
        g.geo_location_key

    from source w
    left join geo_locations g
        on initcap(trim(w.city)) = g.city
        and upper(trim(w.state)) = g.state_code

)

select * from final