-- gold dim date

create or replace view gold.dim_date as

select 
	row_number() over (order by sft.trans_date_trans_time asc ) as date_key,
	sft.trans_date_trans_time,
	sft.trans_day_of_week,
	sft.unix_time

from silver.sparkov_fraud_test sft
