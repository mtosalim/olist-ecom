with source as (
    select *
    from {{ source('olist_bronze', 'olist_order_items_dataset') }}
),

renamed_and_casted as (
    select
        replace(order_id, '"', '') as order_id,
        safe_cast(order_item_id as int64) as order_item_id,
        replace(product_id, '"', '') as product_id,
        replace(seller_id, '"', '') as seller_id,
        safe_cast(shipping_limit_date as timestamp) as shipping_limit_timestamp,
        safe_cast(price as numeric) as price,
        safe_cast(freight_value as numeric) as freight_value
    from source
)

select *
from renamed_and_casted