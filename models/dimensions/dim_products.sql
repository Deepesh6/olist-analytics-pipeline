{{ config(materialized='table') }} 
with products as (
    select * from {{  ref('stg_products') }}
),

translation as (
    Select * from {{ source('olist_raw', 'product_category_translation') }}
),

cte1 as (
    Select p.product_id, 
    coalesce(t.product_category_name_english, p.product_category_name, 'unknown') as product_category
    from products p
    left join translation t
    on p.product_category_name = t.product_category_name
)

Select * from cte1