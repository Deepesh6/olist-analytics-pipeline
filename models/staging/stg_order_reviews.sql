{{ config(materialized='view') }}

with source as (

    select * from {{ source('olist_raw', 'order_reviews') }}

)

, renamed as (

    select
        review_id ,
        order_id ,
        review_score ,
        review_creation_date

    from source

)

select * from renamed