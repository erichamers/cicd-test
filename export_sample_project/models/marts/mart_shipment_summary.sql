with shipment_items as (

    select * from {{ ref('int_shipment_items_enriched') }}

),

shipments as (

    select * from {{ ref('int_shipments_enriched') }}

),

joined as (

    select
        date_trunc('month', s.order_date) as order_month,
        si.therapeutic_area,
        si.product_name,
        s.customer_region,
        s.warehouse_name,
        s.shipment_status,
        si.quantity_shipped,
        si.line_item_revenue_usd,
        s.total_fulfillment_days,
        si.is_controlled_substance

    from shipment_items si
    inner join shipments s on si.shipment_id = s.shipment_id

),

summarized as (

    select
        order_month,
        therapeutic_area,
        product_name,
        customer_region,
        warehouse_name,
        count(distinct shipment_status) as status_count,
        sum(quantity_shipped) as total_units,
        sum(line_item_revenue_usd) as total_revenue_usd,
        avg(total_fulfillment_days) as avg_fulfillment_days,
        sum(case when is_controlled_substance then quantity_shipped else 0 end) as controlled_units

    from joined
    group by
        order_month,
        therapeutic_area,
        product_name,
        customer_region,
        warehouse_name

)

select * from summarized
