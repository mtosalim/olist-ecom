with source as (

    select *
    from {{ source('olist_bronze', 'olist_orders_dataset') }}

),

renamed_and_casted as (

    select
        trim(order_id) as order_id,
        trim(customer_id) as customer_id,
        lower(trim(order_status)) as order_status,
        safe_cast(order_purchase_timestamp as timestamp)
            as order_purchase_timestamp,
        safe_cast(order_approved_at as timestamp)
            as order_approved_at,
        safe_cast(order_delivered_carrier_date as timestamp)
            as order_delivered_carrier_timestamp,
        safe_cast(order_delivered_customer_date as timestamp)
            as order_delivered_customer_timestamp,
        safe_cast(order_estimated_delivery_date as date)
            as order_estimated_delivery_date

    from source

)

select *
from renamed_and_casted