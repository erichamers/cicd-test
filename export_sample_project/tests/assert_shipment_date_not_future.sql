-- This test ensures no order_date is set in the future.
-- Future-dated orders indicate data entry errors or system clock issues.

select
    shipment_id,
    order_date

from {{ ref('stg_shipments') }}

where order_date > current_date()
