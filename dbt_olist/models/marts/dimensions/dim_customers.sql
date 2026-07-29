with customers as (
    select *
    from {{ref('int_customers__enriched')}}
),

dim_customers as (
    select 
        c.customer_id,
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        c.geolocation_lat,
        c.geolocation_lng        
    from customers as c
)

select * from dim_customers