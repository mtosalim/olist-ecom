with source as (
    select *
    from {{ source('olist_bronze', 'olist_geolocation_dataset')}}
),

renamed_and_casted as (
    select
        safe_cast(geolocation_zip_code_prefix as int64) as geolocation_zip_code_prefix,
        safe_cast(geolocation_lat as float64) as geolocation_lat,
        safe_cast(geolocation_lng as float64) as geolocation_lng,
        trim(
            regexp_replace(regexp_replace(normalize(lower(trim(geolocation_city)), NFD), r'\pM', ''), r'\s+', ' ')
        ) as geolocation_city,
        upper(trim(geolocation_state)) as geolocation_state
    from source

)

select *
from renamed_and_casted