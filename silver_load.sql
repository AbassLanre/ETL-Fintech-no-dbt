-- sparkov_fraud_test
-------------------------------------------------------------
truncate table silver.sparkov_fraud_test;
insert into silver.sparkov_fraud_test(
	trans_date_trans_time,
	cc_num,
	merchant,
	category,
	amt,
	first,
	last,
	gender,
	street,
	city,
	state,
	zip,
	lat,
	long ,
	city_pop,
	dob,
	job,
	trans_day_of_week,
	customer_age,
	trans_num,
	unix_time,
	merch_lat,
	merch_long,
	distance_between_cus_merch_km,
	is_fraud,
	dwh_create_date
)
select 
	t.trans_date_trans_time,
	t.cc_num,
	t.merchant,
	case when t.category = '' then 'unknown'
		 else t.category
	end category,
	t.amt,
	t.first,
	t.last,
	t.gender,
	t.street,
	t.city,
	t.state,
	t.zip,
	t.lat,
	t.long ,
	t.city_pop,
	t.dob,
	job,
	to_char(trans_date_trans_time, 'FMDay') as trans_day_of_week,
	date_part('year',age(trans_date_trans_time, dob)) as customer_age,
	t.trans_num,
	t.unix_time,
	t.merch_lat,
	t.merch_long,
	ROUND(
        (
            6371 * ACOS(
                COS(RADIANS(lat))
                * COS(RADIANS(merch_lat))
                * COS(RADIANS(merch_long) - RADIANS(long))
                + SIN(RADIANS(lat))
                * SIN(RADIANS(merch_lat))
            )
        )::numeric,
        2
    ) as distance_between_cus_merch_km,
	t.is_fraud,
	t.dwh_create_date 
from (select
	*,
	row_number() over (partition by sft.trans_num order by sft.trans_date_trans_time desc) as trans_num_
	from bronze.sparkov_fraud_test sft) t
where 
	trans_num_ = 1 and 
	t.trans_num is not null and 
	t.trans_date_trans_time  is not null and 
	t.merchant is not null and 
	t.amt >= 0.01 and 
	t.amt <= 1000000 and 
	t.job is not null;
	

-- Python merchant
-----------------------------------------------------------------------------------------
truncate table silver.python_merchant;
insert into silver.python_merchant(
merchant_id, merchant_name, category, merchant_tier, country, city, commission_rate, is_online, founded_year, is_active, dwh_create_date
)
select
	pt.merchant_id, pt.merchant_name, pt.category, pt.merchant_tier, pt.country, pt.city, pt.commission_rate, pt.is_online, pt.founded_year, pt.is_active, pt.dwh_create_date
from bronze.python_merchant pt;
	
	

-- sparkov_fraud_test dropped items
--------------------------------------------------------------------------------------------
truncate table silver.sparkov_fraud_test_drop;
insert into silver.sparkov_fraud_test_drop(
	trans_date_trans_time,
	cc_num,
	merchant,
	category,
	amt,
	first,
	last,
	gender,
	street,
	city,
	state,
	zip,
	lat,
	long ,
	city_pop,
	dob,
	job,
	trans_day_of_week,
	customer_age,
	trans_num,
	unix_time,
	merch_lat,
	merch_long,
	distance_between_cus_merch_km,
	is_fraud,
	dwh_create_date
)
select 
	t.trans_date_trans_time,
	t.cc_num,
	t.merchant,
	case when t.category = '' then 'unknown'
		 else t.category
	end category,
	t.amt,
	t.first,
	t.last,
	t.gender,
	t.street,
	t.city,
	t.state,
	t.zip,
	t.lat,
	t.long ,
	t.city_pop,
	t.dob,
	t.job,
	to_char(trans_date_trans_time, 'FMDay') as trans_day_of_week,
	date_part('year',age(trans_date_trans_time, dob)) as customer_age,
	t.trans_num,
	t.unix_time,
	t.merch_lat,
	t.merch_long,
	ROUND(
        (
            6371 * ACOS(
                COS(RADIANS(lat))
                * COS(RADIANS(merch_lat))
                * COS(RADIANS(merch_long) - RADIANS(long))
                + SIN(RADIANS(lat))
                * SIN(RADIANS(merch_lat))
            )
        )::numeric,
        2
    ) as distance_between_cus_merch_km,
	t.is_fraud,
	t.dwh_create_date 
from (select
	*,
	row_number() over (partition by sft.trans_num order by sft.trans_date_trans_time desc) as trans_num_
	from bronze.sparkov_fraud_test sft) t
where 
	trans_num_ > 1 or 
	t.trans_num is null or 
	t.trans_date_trans_time  is null or 
	t.merchant is null or 
	t.amt < 0.01 or 
	t.amt > 1000000 or 
	t.job is null;
	
	
	
	
	
	