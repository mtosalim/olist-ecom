
with customers as (
    select *
    from {{ ref('stg_customers') }}
),

geolocation as (
    select
        geo.geolocation_zip_code_prefix,
        geo.geolocation_lat,
        geo.geolocation_lng
    from {{ ref('int_geolocation__aggregated') }} as geo
),

customers_enriched as (
    select
        c.customer_id,
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        g.geolocation_lat,
        g.geolocation_lng
    from customers as c
    left join geolocation as g
        on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
),

final as (
    select * from customers_enriched
)

select * from final