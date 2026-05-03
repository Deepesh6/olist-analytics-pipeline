{{ config(materialized='table') }}

with fct_orders as (
    Select * from {{ref('fct_orders')}}
),

products as (
    Select * from {{ref('dim_products')}}
),

order_reviews as (
    Select * from {{ref('stg_order_reviews')}}
),

final as (
    Select p.product_category,
    round(avg(r.review_score), 2) as avg_rating,
    count(distinct o.order_id) as order_volume
    from fct_orders o
    inner join products p
    on o.product_id = p.product_id
    inner join order_reviews r
    on r.order_id = o.order_id

    group by product_category
)

Select * from final
order by order_volume desc, avg_rating desc