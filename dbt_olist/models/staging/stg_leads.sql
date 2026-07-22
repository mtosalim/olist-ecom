with source as (
    select *
    from {{ source('olist_bronze', 'olist_marketing_qualified_leads_dataset') }}
),

renamed_and_casted as (
    select
        trim(mql_id) as mql_id,
        safe_cast(first_contact_date as date) as first_contact_date,
        trim(landing_page_id) as landing_page_id,
        coalesce(origin, 'unknown') as origin
    from source
)

select *
from renamed_and_casted