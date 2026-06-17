with source as (

    select * from {{ ref('raw_shipments') }}

),

renamed as (

    select
        shipment_id,
        customer_id,
        warehouse_id,
        cast(order_date as date) as order_date,
        cast(ship_date as date) as ship_date,
        cast(delivery_date as date) as delivery_date,
        upper(trim(shipment_status)) as shipment_status,
        trim(carrier) as carrier,
        trim(tracking_number) as tracking_number,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
