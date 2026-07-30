with orders as (
    select *
    from {{ref('int_orders__enriched')}}
),

fct_orders as (
    select
        o.order_id,
        o.customer_id,
        o.order_status,
        o.order_purchase_timestamp,
        date(o.order_purchase_timestamp) as order_purchase_date,
        o.order_approved_at,
        date(o.order_approved_at) as order_approved_date,
        o.order_delivered_carrier_timestamp,
        date(o.order_delivered_carrier_timestamp) as order_delivered_carrier_date,
        o.order_delivered_customer_timestamp,
        date(o.order_delivered_customer_timestamp) as order_delivered_customer_date,
        o.order_estimated_delivery_date,

        o.order_item_count,
        o.distinct_product_count,
        o.distinct_seller_count,
        o.total_product_value,
        o.total_freight_value,
        o.total_order_item_value,
        o.payment_count,
        o.distinct_payment_type_count,
        o.primary_payment_type,
        o.total_payment_value,
        o.max_installments,
        
        o.review_id,
        o.review_score,
        o.review_comment_title,
        o.review_comment_message,
        o.review_creation_date,
        o.review_answer_timestamp
    from orders as o        
)

select *
from fct_orders