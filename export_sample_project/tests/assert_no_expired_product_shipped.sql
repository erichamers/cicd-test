-- This test ensures no product is shipped past its expiration date.
-- Expired pharmaceuticals must never be dispatched to customers.

select
    si.shipment_item_id,
    si.shipment_id,
    si.lot_number,
    si.expiration_date,
    s.ship_date

from {{ ref('stg_shipment_items') }} si
inner join {{ ref('stg_shipments') }} s
    on si.shipment_id = s.shipment_id

where s.ship_date is not null
  and si.expiration_date < s.ship_date
