{{ config(materialized='table') }}

with order_items as (
    select * from {{ ref('stg_order_items') }}
),

order_reviews as (
    Select * from {{ ref('stg_order_reviews')}}
),

products as (
    Select * from {{ ref('stg_products') }}
),

translation as (
    Select * from {{ source('olist_raw', 'product_category_translation') }}
)

, final as (
    Select coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as category_name, 
    round(avg(review_score), 2) as avg_rating,
    count(distinct i.order_id) as order_volume
    from order_items i
    inner join order_reviews r
    on i.order_id = r.order_id
    inner join products p
    on i.product_id = p.product_id
    left join translation t
    on p.product_category_name = t.product_category_name

    group by coalesce(t.product_category_name_english, p.product_category_name, 'unknown')
    
)
Select * from final
order by order_volume desc, avg_rating desc