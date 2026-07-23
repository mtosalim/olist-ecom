with payments as (
    select *
    from {{ref('stg_order_payments')}}
),

payment_type_totals as (
    select
        p.order_id,
        p.payment_type as payment_type,
        sum(p.payment_value) as payment_type_value
    from payments as p
    group by p.order_id, p.payment_type
),

ranked_payment_types as (
    select
        ptt.order_id,
        ptt.payment_type,
        ptt.payment_type_value,
        row_number() over (partition by ptt.order_id order by ptt.payment_type_value desc, ptt.payment_type asc) as payment_type_rank
    from payment_type_totals as ptt
),

primary_payment_types as (
    select
        rpt.order_id,
        rpt.payment_type as primary_payment_type
    from ranked_payment_types rpt
    where rpt.payment_type_rank = 1
    order by rpt.payment_type asc
),

payments_aggregated as (
    select
        p.order_id,
        count(*) as payment_count,
        count(distinct p.payment_type) as distinct_payment_type_count,
        sum(p.payment_value) as total_payment_value,
        max(case 
            when p.payment_installments > 0 then p.payment_installments
        end) as max_installments
    from payments p
    group by p.order_id
),

final as (
    select
        pa.order_id,
        pa.payment_count,
        pa.distinct_payment_type_count,
        ppt.primary_payment_type,
        pa.total_payment_value,
        pa.max_installments,
    from payments_aggregated as pa
    join primary_payment_types as ppt
        on pa.order_id = ppt.order_id
)

select * from final