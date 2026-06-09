

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


select * from gold.fact_transaction ft 
where ft.merchant_key = -1