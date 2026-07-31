with order_items as (
    select *
    from {{ ref('fct_order_items') }}
),

orders as (
    select
        order_id,
        order_purchase_date,
        order_status,
        review_score
    from {{ ref('fct_orders') }}
),

products as (
    select *
    from {{ ref('dim_products') }}
),

sellers as (
    select *
    from {{ ref('dim_sellers') }}
),

products_and_sellers as (
    select
        oi.order_id,
        oi.order_item_id,

        o.order_purchase_date,
        o.order_status,
        o.order_status = 'delivered' as is_delivered,

        oi.product_id,
        p.product_category_name,
        p.product_category_name_english,

        oi.seller_id,
        s.seller_city_normalized,
        s.seller_state,
        s.geolocation_lat as seller_lat,
        s.geolocation_lng as seller_lng,

        oi.shipping_limit_timestamp,
        oi.price,
        oi.freight_value,
        oi.order_item_total_value,

        o.review_score

    from order_items as oi

    left join orders as o
        on oi.order_id = o.order_id

    left join products as p
        on oi.product_id = p.product_id

    left join sellers as s
        on oi.seller_id = s.seller_id
)

select *
from products_and_sellers