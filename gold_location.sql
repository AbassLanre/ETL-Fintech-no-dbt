-- gold dim location

create or replace view gold.dim_location as

select 
	row_number() over (order by t.zip asc ) as location_key,
	t.city,
	t.state ,
	t.zip,
	t.city_pop
from (select
		*, 
		row_number() over (partition by sft.zip ) as trans_numm
		from silver.sparkov_fraud_test sft) t
where trans_numm =1


--select 
--	count(*)
--from (select
--		*, 
--		row_number() over (partition by sft.zip) as trans_numm
--		from silver.sparkov_fraud_test sft) t
--where trans_numm =1


-- below is some how faster
--select 
--	count(*)
--from (select distinct
--		sft.zip
----		row_number() over (partition by sft.zip) as trans_numm
--		from silver.sparkov_fraud_test sft
--		order by sft.zip desc) t