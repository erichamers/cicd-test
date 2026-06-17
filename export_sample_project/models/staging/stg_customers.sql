with source as (

    select * from {{ ref('raw_customers') }}

),

renamed as (

    select
        customer_id,
        trim(customer_name) as customer_name,
        trim(customer_type) as customer_type,
        trim(address_line_1) as address_line_1,
        trim(city) as city,
        trim(state) as state,
        trim(zip_code) as zip_code,
        trim(region) as region,
        trim(dea_number) as dea_number,
        cast(is_active as boolean) as is_active,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
