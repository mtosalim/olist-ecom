with products as (
    select *
    from {{ ref('int_products__translated') }}
),

dim_products as (
    select
        p.product_id,
        p.product_category_name,
        coalesce(p.product_category_name_english, 'unknown') as product_category_name_english,
        p.product_name_length,
        p.product_description_length,
        p.product_photos_qty,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm
    from products as p
)

select * from dim_products