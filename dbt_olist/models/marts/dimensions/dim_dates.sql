with date_limits as (
    select
        MIN(date(order_purchase_timestamp)) as start_date,
        MAX(GREATEST(date(order_purchase_timestamp), order_estimated_delivery_date)) as end_date
    from {{ ref('fct_orders') }}
),

date_spine as (
    select
        date_day
    from date_limits
    cross join unnest(
        generate_date_array(start_date, end_date)
    ) as date_day
),

dim_dates as (
    select
        date_day,
        extract(YEAR FROM date_day) AS year,
        EXTRACT(QUARTER FROM date_day) AS quarter,
        EXTRACT(MONTH FROM date_day) AS month,
        FORMAT_DATE('%B', date_day) AS month_name,
        FORMAT_DATE('%Y-%m', date_day) AS year_month,
        CAST(FORMAT_DATE('%U', date_day) AS INT64) AS week_of_year,
        EXTRACT(DAY FROM date_day) AS day_of_month,
        EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week,
        FORMAT_DATE('%A', date_day) AS day_name,
        IF(EXTRACT(DAYOFWEEK FROM date_day) IN (1, 7), TRUE, FALSE) AS is_weekend
    from date_spine
)

select *
from dim_dates