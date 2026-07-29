with order_items as (
    select *
    from {{ ref('int_order_items__enriched') }}
),

fct_order_items as (
    select 
        o.order_id,
        o.order_item_id,
        o.product_id,
        o.seller_id,
        o.shipping_limit_timestamp,
        o.price,
        o.freight_value,
        o.order_item_total_value
    from order_items as o
)

select *
from fct_order_items