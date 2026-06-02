
DROP VIEW gold.dim_merchants;
create view gold.dim_merchants as
select 
row_number() over (order by merchant_id) merchant_key,
merchant_id,
merchant_name, 
category,
merchant_tier, 
country, 
city, 
commission_rate, 
is_online,
founded_year, 
is_active
from silver.python_merchant pm 


DROP VIEW gold.fact_sparkov_fraud_test;
create view gold.fact_sparkov_fraud_test as
select 
 sft.trans_date_trans_time,
 sft.cc_num,
 pm.merchant_key,
 sft.merchant,
 sft.category,
 sft.amt, 
 sft.first, 
 sft.last,
 sft.gender,
 sft.street,
 sft.city,
 sft.state, 
 sft.zip,
 sft.lat,
 sft.long,
 sft.city_pop,
 sft.job, 
 sft.dob,
 sft.trans_num,
 sft.unix_time, 
 sft.merch_lat, 
 sft.merch_long,
 sft.is_fraud
 
from silver.sparkov_fraud_test sft 
left join gold.dim_merchants pm 
on pm.merchant_name  = sft.merchant 


select * from gold.fact_sparkov_fraud_test fsft 
where fsft.merchant_key = 419;

select * from gold.dim_merchants dm 
where dm.merchant_key = 419














