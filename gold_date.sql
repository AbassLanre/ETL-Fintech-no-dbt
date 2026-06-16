-- gold dim date

-- it should have a row per calendar date and is not dependant on the sparkov table

 drop view if exists gold.dim_date;
drop table if exists gold.dim_date;

create table gold.dim_date as
select 
    to_char(d, 'YYYYMMDD')::int    as date_key,
    d                              as full_date,
    extract(year from d)::int      as year,
    extract(quarter from d)::int   as quarter,
    extract(month from d)::int     as month,
    to_char(d, 'FMMonth')          as month_name,
    extract(day from d)::int       as day_of_month,
    to_char(d, 'FMDay')            as day_of_week_name,
    case when extract(dow from d) in (0, 6) then true else false end as is_weekend
from generate_series(
    '2018-01-01'::date,   --  earliest Sparkov date 
    '2025-12-31'::date,   --  latest
    interval '1 day'
) as d;


