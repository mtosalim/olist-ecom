
with reviews as (
    select *
    from {{ref('stg_order_reviews')}}
),

reviews_ranked as (
    select 
        *,
        row_number() over (partition by r.order_id order by r.review_answer_timestamp desc, r.review_id desc) as review_recent_rank
    from reviews r
),

reviews_deduplicated as (
    select 
        r.order_id,
        r.review_id,
        r.review_score,
        r.review_comment_title,
        r.review_comment_message,
        r.review_creation_date,
        r.review_answer_timestamp
    from reviews_ranked as r
    where review_recent_rank = 1
)

select * from reviews_deduplicated