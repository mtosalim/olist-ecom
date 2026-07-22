with products as (

    select *
    from {{ ref('stg_products') }}

),

product_category_translation as (

    select *
    from {{ ref('stg_product_category') }}

),

products_enriched as (
    select
        pd.product_id,
        pd.product_category_name,
        pct.product_category_name_english,
        pd.product_name_length,
        pd.product_description_length,
        pd.product_photos_qty,
        pd.product_weight_g,
        pd.product_length_cm,
        pd.product_height_cm,
        pd.product_width_cm
    from products as pd
    left join product_category_translation as pct
    on pd.product_category_name = pct.product_category_name
)

select *
from products_enriched

