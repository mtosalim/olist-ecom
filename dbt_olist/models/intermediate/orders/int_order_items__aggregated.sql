
with order_items as (
    select *
    from {{ref('stg_order_items')}}
),

order_items_aggregated as (
    select
        od.order_id,
        count(*) as order_item_count,
        count(distinct od.product_id) as distinct_product_count,
        count(distinct od.seller_id) as distinct_seller_count,
        sum(od.price) as total_product_value,
        sum(od.freight_value) as total_freight_value,
        sum(od.price) + sum(od.freight_value) as total_order_item_value
    from order_items as od
    group by od.order_id
)

select * from order_items_aggregated