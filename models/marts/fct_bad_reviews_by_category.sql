{{ config(materialized='table') }}


with order_items as (
    Select * from {{ ref('stg_order_items')}}
),
reviews as (
    Select * from {{ ref('stg_order_reviews')}}
),
products as (
    Select * from {{ref('stg_products')}}
),
translation as (
    Select * from {{source('olist_raw', 'product_category_translation')}}
)

, final as (
    Select coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category_name,
    sum(case when review_score <= 2 then 1 else 0 end) as bad_reviews, 
    count(review_score) as total_reviews,  
    round(sum(case when review_score <= 2 then 1 else 0 end)*100.0/count(review_score), 2) as bad_review_percentage
    from order_items o
    inner join reviews r
    on o.order_id = r.order_id
    inner join products p
    on o.product_id = p.product_id 
    left join translation t 
    on p.product_category_name = t.product_category_name


    group by coalesce(t.product_category_name_english, p.product_category_name, 'unknown')
)

Select * from final
order by bad_review_percentage desc