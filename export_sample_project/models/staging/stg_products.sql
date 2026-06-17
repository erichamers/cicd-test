with source as (

    select * from {{ ref('raw_products') }}

),

renamed as (

    select
        product_id,
        trim(product_name) as product_name,
        trim(ndc_code) as ndc_code,
        trim(therapeutic_area) as therapeutic_area,
        trim(dosage_form) as dosage_form,
        cast(unit_price_usd as decimal(10, 2)) as unit_price_usd,
        cast(is_controlled_substance as boolean) as is_controlled_substance,
        trim(dea_schedule) as dea_schedule,
        current_timestamp() as _loaded_at

    from source

)

select * from renamed
