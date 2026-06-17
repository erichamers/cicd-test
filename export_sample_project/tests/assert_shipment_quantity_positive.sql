-- This test ensures no shipment line item has a non-positive quantity.
-- Pharmaceutical shipments must always have at least 1 unit shipped.
-- Any rows returned by this query indicate a data quality issue.

select
    shipment_item_id,
    shipment_id,
    product_id,
    quantity_shipped

from {{ ref('stg_shipment_items') }}

where quantity_shipped <= 0
