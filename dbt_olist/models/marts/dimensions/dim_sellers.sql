with sellers as (
    select *
    from {{ref('int_sellers__enriched')}}
),

dim_sellers as (
    select
        s.seller_id,
        s.seller_zip_code_prefix,
        s.seller_city_normalized,
        s.seller_state,
        s.geolocation_lat,
        s.geolocation_lng
    from sellers as s
)

select * from dim_sellers