{{ config(materialized='table') }}

with payments as (
    Select * from {{ ref ('stg_order_payments')}}
)

, final as (
    Select payment_type, 
    count(distinct order_id) as count_payment_type,
    avg(payment_installments) as avg_intallment_period
    from payments
    group by payment_type
)

Select * from final
order by count_payment_type desc