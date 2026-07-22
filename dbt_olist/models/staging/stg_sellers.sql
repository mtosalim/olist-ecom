with source as (

    select *
    from {{ source('olist_bronze', 'olist_sellers_dataset') }}

),

renamed_and_casted as (

    select
        trim(seller_id) as seller_id,
        safe_cast(seller_zip_code_prefix as int64) as seller_zip_code_prefix,
        seller_city as seller_city_raw,
        trim(
            regexp_replace(regexp_replace(normalize(lower(trim(seller_city)), NFD), r'\pM', ''), r'\s+', ' ')
        ) as seller_city_normalized,
        upper(trim(seller_state)) as seller_state

    from source

)

select *
from renamed_and_casted