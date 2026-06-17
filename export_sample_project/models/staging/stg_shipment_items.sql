with source as (

    select * from {{ ref('raw_shipment_items') }}

),

renamed as (

    select
        shipment_item_id,
        shipment_id,
        product_id,
        cast(quantity_shipped as integer) as quantity_shipped,
        trim(lot_number) as lot_number,
        cast(expiration_date as date) as expiration_date,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
