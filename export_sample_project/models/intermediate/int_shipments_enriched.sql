with shipments as (

    select * from {{ ref('stg_shipments') }}

),

customers as (

    select * from {{ ref('dim_customers') }}

),

warehouses as (

    select * from {{ ref('dim_warehouses') }}

),

enriched as (

    select
        s.shipment_id,
        s.customer_id,
        s.warehouse_id,
        s.order_date,
        s.ship_date,
        s.delivery_date,
        s.shipment_status,
        s.carrier,
        s.tracking_number,
        datediff('day', s.order_date, s.ship_date) as days_to_ship,
        datediff('day', s.ship_date, s.delivery_date) as days_in_transit,
        datediff('day', s.order_date, s.delivery_date) as total_fulfillment_days,
        c.customer_name,
        c.customer_type,
        c.city as customer_city,
        c.state as customer_state,
        c.region as customer_region,
        c.is_active as customer_is_active,
        c.geo_location_key as customer_geo_location_key,
        w.warehouse_name,
        w.city as warehouse_city,
        w.state as warehouse_state,
        w.geo_location_key as warehouse_geo_location_key

    from shipments s
    left join customers c on s.customer_id = c.customer_id
    left join warehouses w on s.warehouse_id = w.warehouse_id

)

select * from enriched
