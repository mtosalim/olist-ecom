with source as (
    select *
    from {{ source('olist_bronze', 'olist_closed_deals_dataset')}}
),

renamed_and_casted as (
    
    select
        trim(mql_id) as mql_id,
        trim(seller_id) as seller_id,
        trim(sdr_id) as sdr_id,
        trim(sr_id) as sr_id,
        safe_cast(won_date as timestamp) as won_date,
        lower(trim(business_segment)) as business_segment,
        lower(trim(lead_type)) as lead_type,
        lower(trim(lead_behaviour_profile)) as lead_behaviour_profile,
        has_company,
        has_gtin,
        trim(average_stock) as average_stock,
        lower(trim(business_type)) as business_type,
        safe_cast(declared_product_catalog_size as float64) as declared_product_catalog_size,
        safe_cast(declared_monthly_revenue as float64) as declared_monthly_revenue
                
    from source
)

select *
from renamed_and_casted