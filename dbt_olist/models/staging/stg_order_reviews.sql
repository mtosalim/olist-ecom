with source as (
    select *
    from {{ source('olist_bronze', 'olist_order_reviews') }}
),

renamed_and_casted as (
    select
        trim(review_id) as review_id,
        trim(order_id) as order_id,
        safe_cast(review_score as int64) as review_score,
        trim(review_comment_title) as review_comment_title,
        coalesce(lower(trim(review_comment_message)), 'no review') as review_comment_message,
        safe_cast(review_creation_date as date) as review_creation_date,
        safe_cast(review_answer_timestamp as timestamp) as review_answer_timestamp 
    from source
)

select *
from renamed_and_casted