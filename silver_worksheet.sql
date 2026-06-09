select * from bronze.sparkov_fraud_test sft ;

-- TRANS_NUM
-- 1. check that no null in trans_num
select *
from bronze.sparkov_fraud_test sft
where sft.trans_num is not null;

-- 300 found, remove the null
-- where sft.trans_num is not null

-- check that trans_num is unique, no duplicate
select count(*) from (select 
sft.trans_num,
count(*)
from bronze.sparkov_fraud_test sft
group by sft.trans_num  
having count(*) > 1) t;
-- 11 duplicate trans_num found, selecting 1 dup
select * 
from bronze.sparkov_fraud_test sft 
where sft.trans_num = 'DIRTY_DUP_001';
-- 1,854,194 before picking the latest (business logic)

select count(*) from (select
*,
row_number() over (partition by sft.trans_num order by sft.trans_date_trans_time desc) as trans_num_
from bronze.sparkov_fraud_test sft) t
where t.trans_num  != 1;

-- we check for null in trans_num
select * 
from bronze.sparkov_fraud_test sft 
where sft.trans_num is null; -- 300 of them

-- check for string trailing spaces in trans_num
select * 
from bronze.sparkov_fraud_test sft 
where sft.trans_num !=  TRIM(sft.trans_num);

--nos is not added, dropping the column
alter table bronze.sparkov_fraud_test 
drop column nos;
alter table silver.sparkov_fraud_test 
drop column nos;

-- TRANS_DATE_TRANS_TIME
-- 1. check that no null in trans_date_trans_time

select 
*
from bronze.sparkov_fraud_test sft 
where sft.trans_date_trans_time is null;

-- CC_NUM
-- check for null in cc_num
select count(*) from (select 
*
from bronze.sparkov_fraud_test sft ) t
where t.cc_num - 1000000 > 1;

select 
	count(*)
from (select distinct
		sft.cc_num
		from bronze.sparkov_fraud_test sft
		order by sft.cc_num desc) t
		
select 
	t.cc_num,
	trans_numm
from (select
		*, 
		row_number() over (partition by sft.cc_num) as trans_numm
		from bronze.sparkov_fraud_test sft) t
where trans_numm >1

select 
	t.cc_num,
	t.first,
	t.last,
	trans_numm
from (select
		*, 
		row_number() over (partition by sft.cc_num) as trans_numm
		from bronze.sparkov_fraud_test sft) t
where trans_numm >1

-- MERCHANT
-- check and ensure merchant is not null
select count(*) from (select *
from bronze.sparkov_fraud_test sft )t
where t.merchant is null;
-- check and ensure no white spaces
select
*
from bronze.sparkov_fraud_test sft
where sft.merchant != TRIM(sft.merchant );

-- CATEGORY
-- check and ensure category is not null
select 
*
from bronze.sparkov_fraud_test sft 
where trim(sft.category) is null;
-- check and ensure no white spaces
select 
*
from bronze.sparkov_fraud_test sft 
where sft.category = '' ;

-- check distinct
select distinct
sft.category 
from bronze.sparkov_fraud_test sft ;

-- check and ensure amt is not null or 0 (business logic says amount cannot be 0)
-- check 
select 
	*
from bronze.sparkov_fraud_test sft 
where sft.amt <= 0;

-- amt should not be greater than 1M as per business rules
select 
	*
from bronze.sparkov_fraud_test sft 
where sft.amt > 1000000;

-- no null in firat and last and no spaces
select 
*
from bronze.sparkov_fraud_test sft 
where sft.first = ''

-- GENDER
-- check distinctness of gender
--

select distinct
	sft.gender
from bronze.sparkov_fraud_test sft 

-- STREET
-- check for null and trim for street,city
select 
	sft.street
from bronze.sparkov_fraud_test sft 
where sft.street is null

-- STATE
-- check distinctness of state and leave in standardized code version for storage 
select distinct
	sft.state
from bronze.sparkov_fraud_test sft 

-- null on zip
select
*
from bronze.sparkov_fraud_test sft 
where zip <= 0;

-- null on lat and long
select
*
from bronze.sparkov_fraud_test sft
where sft.long is null;

-- null on city_pop and number should be greater than =0
select
*
from bronze.sparkov_fraud_test sft
where sft.city_pop <= 0;

-- job non null and empty spaces
select
*
from bronze.sparkov_fraud_test sft
where sft.job is null;

-- null on dob
select
*
from bronze.sparkov_fraud_test sft
where sft.dob is null;

-- dob to day of the week
select
to_char(dob, 'FMDay') as daysss
from bronze.sparkov_fraud_test sft

-- dob : cus age
select
date_part('year',age(now(), dob)) as age
from bronze.sparkov_fraud_test sft

-- null on unix_time
select
*
from bronze.sparkov_fraud_test sft
where sft.unix_time is null

-- null on merch_lat and long
select
*
from bronze.sparkov_fraud_test sft
where sft.merch_lat is null

-- distance
select
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
    ) AS distance_km
from bronze.sparkov_fraud_test sft



-- null on isfraud and distinct
select distinct
sft.is_fraud 
from bronze.sparkov_fraud_test sft


-- MERCHANT

select * from bronze.python_merchant pm 

-- lets try something new, something like python df.isnull().sum() but for sql

select 
count(*) filter (where pm.merchant_id is null) merchant_id,
count(*) filter (where pm.merchant_name is null) merchant_name,
count(*) filter (where pm.category is null) category,
count(*) filter (where pm.merchant_tier is null) merchant_tier,
count(*) filter (where pm.country is null) country,
count(*) filter (where pm.city is null) city,
count(*) filter (where pm.commission_rate is null) commission_rate,
count(*) filter (where pm.is_online is null) is_online,
count(*) filter (where pm.founded_year is null) founded_year,
count(*) filter (where pm.is_active is null) is_active

from bronze.python_merchant pm 

-- no null in the table
-- the table was generated by me so it doesn't need any transformation to be done to the silver layer



-- count of silver sparkov_fraud_test

select
	count(*) 
from silver.sparkov_fraud_test sft
-- 1,852,628

-- count of dropped silver sparkov_fraud_test
select count(*) from silver.sparkov_fraud_test_drop sftd 
-- 1566

-- 1,852,628 + 1566 = 1,854,194

