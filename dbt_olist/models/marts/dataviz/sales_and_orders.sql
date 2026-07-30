
with dates as (
    select *
    from {{ref('dim_dates')}}
),

salesorders as (
    select *
    from {{ref('fct_orders')}}
),

sales_and_orders as (
    select
        d.date_day,
        count(so.order_id) as total_orders,
        count(case when so.order_status = 'delivered' then 1 end) as delivered_orders,
        count(case when so.order_status = 'canceled' then 1 end) as canceled_orders,
        coalesce(
            sum(
                case
                    when so.order_status = 'delivered'
                    then so.total_payment_value
                    else 0
                end
                ), 0
            ) as delivered_gmv,
        coalesce(
            avg(
                case
                    when so.order_status = 'delivered'
                    then so.total_payment_value
                end
                ), 0
            ) as avg_order_value,
        coalesce(
            sum(
                case
                    when so.order_status = 'delivered'
                    then so.order_item_count
                    else 0
                end
                ), 0
            ) as items_sold,
        coalesce(
            sum(
                case
                    when so.order_status = 'delivered'
                    then so.total_freight_value
                    else 0
                end
                ), 0
            ) as freight_value

    from dates as d
    left join salesorders as so
    on d.date_day = so.order_purchase_date
    where d.date_day <= (
        select max(order_purchase_date) 
        from salesorders)
    group by d.date_day
)

select *
from sales_and_orders