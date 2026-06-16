

select 
    count(*) filter (where customer_key is null) as null_customer,
    count(*) filter (where merchant_key  is null) as null_merchant,
    count(*) filter (where location_key  is null) as null_location,
    count(*) filter (where date_key      is null) as null_date,
     count(*) filter (where trans_num is null) as null_trans_num,
      count(*) filter (where trans_date_trans_time is null) as null_trans_date_trans_time,
       count(*) filter (where amt is null) as null_amt,
        count(*) filter (where merch_lat is null) as null_merch_lat,
         count(*) filter (where merch_long is null) as null_merch_long,
          count(*) filter (where distance_between_cus_merch_km is null) as null_distance_between_cus_merch_km,
                   count(*) filter (where is_fraud is null) as null_is_fraud
from gold.fact_transaction ft;


select * from gold.dim_merchant dm  
where dm.merchant_key = -1


-- count of all dates that have zero transaction
select count(*) from (select 
    dd.full_date,
    dd.day_of_week_name
from gold.dim_date dd
left join gold.fact_transaction ft
    on ft.date_key = dd.date_key
where ft.date_key is null           
order by dd.full_date) t;
-- all dates that have zero transaction
select 
    dd.full_date,
    dd.day_of_week_name
from gold.dim_date dd
left join gold.fact_transaction ft
    on ft.date_key = dd.date_key
where ft.date_key is null           
order by dd.full_date;

-- fraud rate by day of week
select dd.day_of_week_name, 
       round(100.0 * sum(ft.is_fraud) / count(*), 2) as fraud_pct
from gold.fact_transaction ft
join gold.dim_date dd on dd.date_key = ft.date_key
group by dd.day_of_week_name
order by fraud_pct desc;

-- fraud rate weekend vs weekday  
select dd.is_weekend, 
       round(100.0 * sum(ft.is_fraud) / count(*), 2) as fraud_pct
from gold.fact_transaction ft
join gold.dim_date dd on dd.date_key = ft.date_key
group by dd.is_weekend;

-- fraud rate by month
select dd.month_name,
       count(*) as txns,
       sum(ft.is_fraud) as frauds
from gold.fact_transaction ft
join gold.dim_date dd on dd.date_key = ft.date_key
group by dd.month_name, dd.month
order by dd.month desc;