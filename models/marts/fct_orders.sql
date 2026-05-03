{{ config(materialized='table') }}

with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        oi.order_id,
        oi.order_item_id,
        o.customer_id,
        oi.product_id,
        o.order_date,
        o.order_status,
        oi.price,
        oi.freight_value
    from order_items oi
    inner join orders o
        on oi.order_id = o.order_id
)

select * from final