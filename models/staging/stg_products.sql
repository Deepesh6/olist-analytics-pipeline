{{ config(materialized='view') }}

with source as (

    select * from {{ source('olist_raw', 'products') }}

)

, renamed as (

    select
        product_id,
        product_category_name

    from source

)

select * from renamed