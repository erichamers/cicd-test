with shipments as (

    select * from {{ ref('int_shipments_enriched') }}

),

shipment_items as (

    select * from {{ ref('int_shipment_items_enriched') }}

),

items_aggregated as (

    select
        shipment_id,
        count(*) as total_line_items,
        sum(quantity_shipped) as total_units_shipped,
        sum(line_item_revenue_usd) as total_revenue_usd,
        count(distinct product_id) as distinct_products,
        sum(case when is_controlled_substance then quantity_shipped else 0 end) as controlled_substance_units,
        max(expiration_date) as latest_expiration_date,
        min(expiration_date) as earliest_expiration_date

    from shipment_items
    group by shipment_id

),

final as (

    select
        md5(cast(coalesce(cast(s.shipment_id as varchar), '') as varchar)) as shipment_key,
        s.shipment_id,
        s.customer_id,
        s.warehouse_id,
        s.customer_geo_location_key,
        s.warehouse_geo_location_key,
        s.order_date,
        s.ship_date,
        s.delivery_date,
        s.shipment_status,
        s.carrier,
        s.tracking_number,
        s.days_to_ship,
        s.days_in_transit,
        s.total_fulfillment_days,
        s.customer_name,
        s.customer_type,
        s.customer_region,
        s.warehouse_name,
        s.warehouse_state,
        ia.total_line_items,
        ia.total_units_shipped,
        ia.total_revenue_usd,
        ia.distinct_products,
        ia.controlled_substance_units,
        ia.earliest_expiration_date,
        ia.latest_expiration_date,
        case
            when s.total_fulfillment_days <= 2 then 'Express'
            when s.total_fulfillment_days <= 4 then 'Standard'
            when s.total_fulfillment_days > 4 then 'Delayed'
            else 'Pending'
        end as fulfillment_tier

    from shipments s
    left join items_aggregated ia on s.shipment_id = ia.shipment_id

)

select * from final