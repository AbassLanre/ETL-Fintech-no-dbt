
do $$
BEGIN
raise notice 'started bronze ddl';
end
$$;
DROP TABLE if EXISTS bronze.sparkov_fraud_test ;
CREATE TABLE bronze.sparkov_fraud_test(
trans_date_trans_time timestamp,
cc_num BIGINT,
merchant TEXT,
category VARCHAR(50),
amt numeric(19,4),
first VARCHAR(50),
last VARCHAR(50),
gender VARCHAR(50),
street TEXT,
city VARCHAR(50),
state VARCHAR(50),
zip INTEGER,
lat numeric(19,4),
long numeric(19,4),
city_pop INTEGER,
job TEXT,
dob date,
trans_num VARCHAR(50),
unix_time BIGINT,
merch_lat numeric(19,4),
merch_long numeric(19,4),
is_fraud INTEGER,
dwh_create_date timestamp DEFAULT NOW()
);
do $$
BEGIN
raise notice 'finished bronze ddl';
end
$$;


do $$
BEGIN
raise notice 'started bronze merchant ddl';
end
$$;
DROP TABLE if EXISTS bronze.python_merchant ;
CREATE TABLE bronze.python_merchant(
merchant_id VARCHAR(50),
merchant_name VARCHAR(50),
category VARCHAR(50),
merchant_tier VARCHAR(50),
country VARCHAR(50),
city VARCHAR(50),
commission_rate numeric(19,4),
is_online BOOLEAN,
founded_year INTEGER,
is_active BOOLEAN,
dwh_create_date TIMESTAMP DEFAULT NOW()
);
do $$
BEGIN
raise notice 'finished bronze merchant ddl';
end
$$;
