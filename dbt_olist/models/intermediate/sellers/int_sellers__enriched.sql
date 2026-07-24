with sellers as (
    select *
    from {{ ref('stg_sellers') }}
),

geolocation as (
    select
        geo.geolocation_zip_code_prefix,
        geo.geolocation_lat,
        geo.geolocation_lng
    from {{ ref('int_geolocation__aggregated') }} as geo
),

sellers_enriched as (
    select
        s.seller_id,
        s.seller_zip_code_prefix,
        s.seller_city_normalized,
        s.seller_state,
        g.geolocation_lat,
        g.geolocation_lng
    from sellers as s
    left join geolocation as g
        on s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
)

select * from sellers_enriched