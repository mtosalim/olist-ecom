with source as (
    select *
    from {{source('olist_bronze', 'olist_products_dataset')}}
),

renamed_and_casted as (
    select
        trim(product_id) as product_id,
        coalesce(trim(product_category_name), 'unknown') as product_category_name,
        safe_cast(product_name_lenght as int64) as product_name_length,
        safe_cast(product_description_lenght as int64) as product_description_length,
        safe_cast(product_photos_qty as int64) as product_photos_qty,
        safe_cast(product_weight_g as int64) as product_weight_g,
        safe_cast(product_length_cm as int64) as product_length_cm,
        safe_cast(product_height_cm as int64) as product_height_cm,
        safe_cast(product_width_cm as int64) as product_width_cm
    from source
)

select *
from renamed_and_casted