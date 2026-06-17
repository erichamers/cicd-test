with source as (

    select * from {{ ref('raw_warehouses') }}

),

renamed as (

    select
        warehouse_id,
        trim(warehouse_name) as warehouse_name,
        trim(city) as city,
        trim(state) as state,
        cast(capacity_units as integer) as capacity_units,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
