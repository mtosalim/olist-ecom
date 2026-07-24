with orders as (
    select *
    from {{ref('stg_orders')}}
),

customers as (
    select *
    from {{ref('int_customers__enriched')}}
),

order_items as (
        select *
    from {{ref('int_order_items__aggregated')}}
),

payments as (
        select *
    from {{ref('int_order_payments__aggregated')}}
),

reviews as (
        select *
    from {{ref('int_order_reviews__deduplicated')}}
),

orders_enriched as (
    select
        ord.order_id,
        ord.customer_id,
        ord.order_status,
        ord.order_purchase_timestamp,
        ord.order_approved_at,
        ord.order_delivered_carrier_timestamp,
        ord.order_delivered_customer_timestamp,
        ord.order_estimated_delivery_date,
        -- dados do cliente
        ctm.customer_unique_id,
        ctm.customer_zip_code_prefix,
        ctm.customer_city,
        ctm.customer_state,
        ctm.geolocation_lat,
        ctm.geolocation_lng,
        -- métricas dos itens
        oit.order_item_count,
        oit.distinct_product_count,
        oit.distinct_seller_count,
        oit.total_product_value,
        oit.total_freight_value,
        oit.total_order_item_value,
        -- métricas de pagamento
        pay.payment_count,
        pay.distinct_payment_type_count,
        pay.primary_payment_type,
        pay.total_payment_value,
        pay.max_installments,
        -- dados da avaliação
        rvw.review_id,
        rvw.review_score,
        rvw.review_comment_title,
        rvw.review_comment_message,
        rvw.review_creation_date,
        rvw.review_answer_timestamp
    from orders as ord
    left join customers as ctm
        on ord.customer_id = ctm.customer_id
    left join order_items as oit
        on ord.order_id = oit.order_id
    left join payments as pay
        on ord.order_id = pay.order_id
    left join reviews as rvw
        on ord.order_id = rvw.order_id
)

select *
from orders_enriched