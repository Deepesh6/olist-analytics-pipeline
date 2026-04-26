
{{ config(materialized='view') }}

with source as (

    select * from {{ source('olist_raw', 'order_payments') }}

)

, renamed as (

    select
        order_id,
        payment_type, 
        payment_installments,
        payment_value

    from source

)

select * from renamed
