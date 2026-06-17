with source as (

    select * from {{ ref('stg_products') }}

),

final as (

    select
        md5(cast(coalesce(cast(product_id as varchar), '') as varchar)) as product_key,
        product_id,
        product_name,
        ndc_code,
        therapeutic_area,
        dosage_form,
        unit_price_usd,
        is_controlled_substance,
        dea_schedule,
        case
            when unit_price_usd >= 5000 then 'Premium'
            when unit_price_usd >= 2000 then 'High'
            when unit_price_usd >= 500 then 'Standard'
            else 'Economy'
        end as price_tier

    from source

)

select * from final