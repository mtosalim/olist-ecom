with order_items as (
    select *
    from {{ref('stg_order_items')}}
),

products as (
    select *
    from {{ref('int_products__translated')}}
),

sellers as (
    select *
    from {{ref('int_sellers__enriched')}}
),

order_items_enriched as (
    select
        o.order_id,
        o.order_item_id,
        o.product_id,
        o.seller_id,
        o.price,
        o.freight_value,
        o.shipping_limit_timestamp,
        o.price + o.freight_value as order_item_total_value,

        p.product_category_name,
        p.product_category_name_english,
        p.product_name_length,
        p.product_description_length,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,

        s.seller_zip_code_prefix,
        s.seller_city_normalized,
        s.seller_state
    from order_items as o
    left join products as p
        on o.product_id = p.product_id
    left join sellers as s
        on o.seller_id = s.seller_id
)

select * from order_items_enriched