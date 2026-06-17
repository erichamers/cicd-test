with shipment_items as (

    select * from {{ ref('stg_shipment_items') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

enriched as (

    select
        si.shipment_item_id,
        si.shipment_id,
        si.product_id,
        si.quantity_shipped,
        si.lot_number,
        si.expiration_date,
        p.product_name,
        p.ndc_code,
        p.therapeutic_area,
        p.dosage_form,
        p.unit_price_usd,
        p.is_controlled_substance,
        p.dea_schedule,
        si.quantity_shipped * p.unit_price_usd as line_item_revenue_usd

    from shipment_items si
    left join products p on si.product_id = p.product_id

)

select * from enriched
