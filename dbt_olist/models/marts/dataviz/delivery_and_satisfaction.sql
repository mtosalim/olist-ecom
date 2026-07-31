with dates as (
    select *
    from {{ref('dim_dates')}}
),

salesorders as (
    select *
    from {{ref('fct_orders')}}
),

delivery_and_satisfaction as (
    select 
        d.date_day,
        count(
            case 
            when so.order_status = 'delivered' 
            then 1 
            end) as delivered_orders,
        count(
            case 
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date <= so.order_estimated_delivery_date 
            then 1 
            end) as ontime_orders,
        count(
            case
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date > so.order_estimated_delivery_date 
            then 1 
            end) as late_orders,
        safe_divide(
            count(
            case 
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date <= so.order_estimated_delivery_date 
            then 1 
            end), 
            count(
            case 
            when so.order_status = 'delivered' 
            then 1 
            end)
        ) as pct_ontime_orders,
        avg(
            case
            when so.order_status = 'delivered'
            then date_diff(
                so.order_delivered_customer_date,
                so.order_purchase_date,
                day
            )
            end
        ) as avg_delivered_orders,
        -- Atraso médio somente dos pedidos atrasados
        avg(
            case
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date
                > so.order_estimated_delivery_date
            then date_diff(
                so.order_delivered_customer_date,
                so.order_estimated_delivery_date,
                day
            )
            end
        ) as avg_late_days,
        -- Nota média dos pedidos entregues
        avg(
            case 
            when so.order_status = 'delivered' 
            then so.review_score 
            end
            ) as avg_review_delivered_orders,
        -- Nota média das entregas no prazo
        avg(
            case 
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date <= so.order_estimated_delivery_date 
            then so.review_score 
            end) as avg_review_ontime_orders,
        -- Nota média das entregas atrasadas
        avg(
            case 
            when so.order_status = 'delivered'
            and so.order_delivered_customer_date > so.order_estimated_delivery_date 
            then so.review_score  
            end) as avg_review_late_orders,
        -- Frete médio dos pedidos entregues
        avg(case 
            when so.order_status = 'delivered' 
            then so.total_freight_value
            end) as avg_freight_delivered_orders
    from dates as d
    left join salesorders as so
    on d.date_day = so.order_purchase_date
    where d.date_day <= (
        select max(so.order_purchase_date)
        from salesorders
    )

    group by d.date_day
)

select * 
from delivery_and_satisfaction