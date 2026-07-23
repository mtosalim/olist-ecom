
with geolocation as (
    select *
    from {{ ref('stg_geolocation') }}
),

city_state_frequency as (
    select 
        geolocation.geolocation_zip_code_prefix as gcep,
        geolocation.geolocation_city as gcity,
        geolocation.geolocation_state as gstate,
        count(*) as frequency
    from geolocation
    group by gcep, gcity, gstate
),

city_medians as (
    select
        geolocation.geolocation_zip_code_prefix as gcep,
        geolocation.geolocation_lat as glat,
        geolocation.geolocation_lng as glng
    from geolocation
),

frequencies as (
    select
        csf.gcep,
        csf.gcity,
        csf.gstate,
        csf.frequency,
        ROW_NUMBER() OVER(PARTITION BY csf.gcep ORDER BY csf.frequency DESC, csf.gstate ASC, csf.gcity ASC) as freqtop
    from city_state_frequency as csf
    QUALIFY freqtop = 1
),

medians as (
    select distinct
        med.gcep,
        percentile_cont(med.glat, 0.5) OVER(PARTITION BY med.gcep) as median_lat,
        percentile_cont(med.glng, 0.5) OVER(PARTITION BY med.gcep) as median_lng
    from city_medians as med
),

geolocation_aggregated as (
    select
        f.gcep as geolocation_zip_code_prefix,
        f.gcity as geolocation_city,
        f.gstate as geolocation_state,
        m.median_lat as geolocation_lat,
        m.median_lng as geolocation_lng,
        f.frequency as city_state_frequency
    from frequencies as f
    left join medians as m
    on f.gcep = m.gcep
),

result as (
    select * from geolocation_aggregated
)

select * from result