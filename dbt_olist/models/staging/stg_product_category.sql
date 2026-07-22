with source as (
    select *
    from {{ source('olist_bronze', 'product_category_name_translation') }}
),

renamed_and_casted as (
    select
        trim(string_field_0) as string_field_0,
        trim(string_field_1) as string_field_1
    from source
)

select *
from renamed_and_casted