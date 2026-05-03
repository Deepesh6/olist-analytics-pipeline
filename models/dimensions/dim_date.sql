-- a dimension table with one row per date containing useful attributes

{{ config(materialized='table') }}

with date_spine as (
    select generate_series(
          '2016-01-01'::date,
          '2018-12-31'::date,
          '1 day':: interval
    ):: date as date_day
),

final as (
    select
        to_char(date_day, 'YYYYMMDD')::int  as date_id,
        date_day                             as full_date,
        extract(year from date_day)::int     as year,
        extract(month from date_day)::int    as month,
        extract(quarter from date_day)::int  as quarter,
        to_char(date_day, 'Day')             as day_of_week,
        case when extract(dow from date_day) 
             in (0,6) then true else false 
        end as is_weekend
    from date_spine
)

select * from final