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
    Select product_category, 
    sum(case when review_score <= 2 then 1 else 0 end) as bad_reviews, 
    count(review_score) as total_reviews,  
    round(sum(case when review_score <= 2 then 1 else 0 end)*100.0/count(review_score), 2) as bad_review_percentage
    from fct_orders o 
    inner join products p
    on o.product_id = p.product_id
    inner join order_reviews r
    on o.order_id = r.order_id
    group by p.product_category

)



Select * from final
order by bad_review_percentage desc