

-- for cases where the merchant don't exist in the transaction table


drop view if exists gold.dim_merchant ;

create or replace view gold.dim_merchant as 

select 
    -1                                       as merchant_key,
    'UNKNOWN'                                as merchant_id,
    'UNKNOWN'                                as merchant_name,
    'UNKNOWN'                                as category,
    'UNKNOWN'                                as merchant_tier,
    'UNKNOWN'                                as country,
    'UNKNOWN'                                as city,
    0::numeric(19,4)                         as commission_rate,
    false                                    as is_online,
    0                                        as founded_year,
    false                                    as is_active

union all

select 
row_number() over (order by pm.merchant_id ) as merchant_key,
pm.merchant_id,
pm.merchant_name, 
pm.category, 
pm.merchant_tier, 
pm.country, 
pm.city, 
pm.commission_rate,
pm.is_online, 
pm.founded_year, 
pm.is_active
from silver.python_merchant pm 
where pm.merchant_id != 'UNKNOWN'
