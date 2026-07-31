with orders as (
    select *
    from {{ ref('fct_orders') }}
),

customers as (
    select *
    from {{ ref('dim_customers') }}
),

customer_order_history as (
    select
        o.order_id,
        o.order_purchase_timestamp,
        o.order_purchase_date,
        o.order_status,

        c.customer_id,
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        c.geolocation_lat as customer_lat,
        c.geolocation_lng as customer_lng,

        o.payment_count,
        o.distinct_payment_type_count,
        o.primary_payment_type,
        o.total_payment_value,
        o.max_installments,

        count(*) over (
            partition by c.customer_unique_id
        ) as customer_order_count,

        row_number() over (
            partition by c.customer_unique_id
            order by
                o.order_purchase_timestamp,
                o.order_id
        ) as customer_order_number

    from orders as o

    left join customers as c
        on o.customer_id = c.customer_id
),

customers_and_payments as (
    select
        *,

        customer_order_count > 1 as is_repeat_customer,

        customer_order_number > 1 as is_repeat_order

    from customer_order_history
)

select *
from customers_and_payments