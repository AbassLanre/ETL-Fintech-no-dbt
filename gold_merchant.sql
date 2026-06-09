

-- for cases where the merchant don't exist in the transaction table

insert
	into
	silver.python_merchant (
	merchant_id,
	merchant_name,
	category,
	merchant_tier,
	country,
	city,
	commission_rate,
	is_online,
	founded_year,
	is_active)
	values ('UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 0, false, 0, false);



create or replace view gold.dim_merchant as 

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




SELECT * 
from silver.python_merchant pm 