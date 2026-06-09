-- gold dimension for customers

create or replace view gold.dim_customers as

select 
	row_number() over (order by t.cc_num asc ) as customer_key,
	t.cc_num,
	t.first,
	t.last,
	t.customer_age ,
	t.dob,
	t.job ,
	t.gender,
	t.lat ,
	t.long,
	t.street,
	t.city,
	t.state ,
	t.zip

from (select
	*,
	row_number() over (partition by sft.cc_num) as trans_num_
	from silver.sparkov_fraud_test sft) t
where trans_num_ = 1


--select 
--count(*)
--from (select
--	*,
--	row_number() over (partition by sft.cc_num ) as trans_num_
--	from silver.sparkov_fraud_test sft) t
--where trans_num_ = 1
--

--select count(*) from (select distinct
--sft.first, sft.last , sft.cc_num
--from silver.sparkov_fraud_test sft
--order by sft.cc_num desc) t

