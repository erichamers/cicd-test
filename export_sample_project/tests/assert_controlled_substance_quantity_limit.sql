-- This test validates that controlled substance shipments
-- do not exceed the regulatory quantity limit per line item (100 units).
-- DEA regulations restrict single-shipment quantities of scheduled drugs.

select
    si.shipment_item_id,
    si.shipment_id,
    si.product_id,
    p.product_name,
    p.dea_schedule,
    si.quantity_shipped

from {{ ref('stg_shipment_items') }} si
inner join {{ ref('stg_products') }} p
    on si.product_id = p.product_id

where p.is_controlled_substance = true
  and si.quantity_shipped > 100
