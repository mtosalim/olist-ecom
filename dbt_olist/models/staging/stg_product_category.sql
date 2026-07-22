with source as (
    select *
    from {{ source('olist_bronze', 'product_category_name_translation') }}
),

renamed_and_casted as (
    select
        trim(string_field_0) as product_category_name,
        trim(string_field_1) as product_category_name_english
    from source
)

select *
from renamed_and_casted