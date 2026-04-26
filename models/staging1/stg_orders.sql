{{ config(materialized='view') }}

with source as (

    select * from {{ source('olist_raw', 'orders') }}

)

, renamed as (

    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp as order_date,
        order_delivered_customer_date as delivered_date

    from source

)

select * from renamed