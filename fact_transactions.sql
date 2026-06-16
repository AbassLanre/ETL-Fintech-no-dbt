--do $$
--
--begin
--
--if exists (
--select
--	1
--from
--	information_schema.tables
--where
--	table_schema = 'gold'
--	and table_name = 'fact_transaction'
--
--) then
--
--execute 'TRUNCATE TABLE gold.fact_transaction';
--end if;
--end $$;

drop table if exists gold.fact_transaction ;

CREATE TABLE IF NOT EXISTS gold.fact_transaction (
    customer_key INT,
    merchant_key INT,
    location_key INT,
    date_key INT,
    trans_num VARCHAR(50),
    trans_date_trans_time TIMESTAMP,
    amt NUMERIC,
    merch_lat NUMERIC,
    merch_long NUMERIC,
    distance_between_cus_merch_km NUMERIC,
    is_fraud INT
);

TRUNCATE TABLE gold.fact_transaction;

insert
	into
	gold.fact_transaction (
	customer_key,
	merchant_key,
	location_key,
	date_key,
	trans_num,
	trans_date_trans_time,
	amt,
	merch_lat,
	merch_long,
	distance_between_cus_merch_km,
	is_fraud

)

select
	dc.customer_key,
	coalesce(dm.merchant_key, -1) as merchant_key,
	dl.location_key,
	dd.date_key,
	sft.trans_num,
	sft.trans_date_trans_time,
	sft.amt,
	sft.merch_lat,
	sft.merch_long,
	sft.distance_between_cus_merch_km,
	sft.is_fraud
from
	silver.sparkov_fraud_test sft
left join gold.dim_customers dc
on
	dc.cc_num = sft.cc_num
left join gold.dim_merchant dm
on
	dm.merchant_name = sft.merchant
left join gold.dim_location dl
on
	dl.zip = sft.zip
left join gold.dim_date dd
on
	dd.full_date = sft.trans_date_trans_time::date
	

	
	
