with source as (

    select *
    from {{ source('olist_bronze', 'olist_customers_dataset') }}

),

renamed_and_casted as (

    select
        trim(customer_id) as customer_id,
        trim(customer_unique_id) as customer_unique_id,
        safe_cast(
            customer_zip_code_prefix as int64
        ) as customer_zip_code_prefix,
        coalesce(
            nullif(trim(customer_city), ''),
            'sem dados'
        ) as customer_city,
        coalesce(
            nullif(trim(customer_state), ''),
            'sem dados'
        ) as customer_state

    from source

)

select *
from renamed_and_casted