{{ config(materialized='table') }}

with source as (

    select * from {{ source('olist_raw', 'customers') }}

)
, renamed as(
    Select customer_id, customer_unique_id, customer_city, customer_state
    from source
)

Select * from renamed