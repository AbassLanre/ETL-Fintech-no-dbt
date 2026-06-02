import pandas as pd
import numpy as np
from sqlalchemy import create_engine
from datetime import datetime, timedelta
import random

engine = create_engine("postgresql://postgres:admin123@localhost:5432/fintech_dw")
random.seed(99)

CATEGORIES = [
    'grocery_pos', 'entertainment', 'food_dining', 'personal_care',
    'health_fitness', 'misc_pos', 'misc_net', 'shopping_net',
    'shopping_pos', 'gas_transport', 'home', 'kids_pets', 'travel'
]

GENDERS = ['M', 'F']
STATES = ['TX', 'CA', 'NY', 'FL', 'AZ', 'WA', 'CO', 'IL']

def base_record(i):
    """Generate a structurally valid base record."""
    return {
        'trans_num':             f'DIRTY_{i:05d}',
        'merchant':              f'fraud_DirtyMerchant_{i} LLC',
        'category':              random.choice(CATEGORIES),
        'amt':                   round(random.uniform(10, 500), 2),
        'first':                 f'FirstName{i}',
        'last':                  f'LastName{i}',
        'gender':                random.choice(GENDERS),
        'street':                f'{i} Dirty St',
        'city':                  'TestCity',
        'state':                 random.choice(STATES),
        'zip':                   random.randint(10000, 99999),
        'lat':                   round(random.uniform(25, 48), 4),
        'long':                  round(random.uniform(-120, -70), 4),
        'city_pop':              random.randint(10000, 3000000),
        'job':                   'Tester',
        'dob':                   '1990-01-01',
        'trans_date_trans_time': f'2020-{random.randint(1, 12):02d}-{random.randint(1, 28):02d} 12:00:00',
        'unix_time':             1591000000 - random.randint(0, 315360000),  # random time in last 10 years
        'merch_lat':             round(random.uniform(25, 48), 4),
        'merch_long':            round(random.uniform(-120, -70), 4),
        'is_fraud':              0,
        'cc_num':                random.randint(1000000000000000, 9999999999999999),
    }


def generate_dirty_records():
    records = []
    counter = 1

    # --- Pattern 1: Negative amounts (200 records) ---
    for _ in range(300):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_NEG_{counter:04d}'
        r['amt'] = round(random.uniform(-500, -0.01), 2)
        records.append(r)
        counter += 1

    # --- Pattern 2: Null trans_num (200 records) ---
    for _ in range(300):
        r = base_record(counter)
        r['trans_num'] = None
        records.append(r)
        counter += 1

    # --- Pattern 3: Null transaction date (150 records) ---
    for _ in range(250):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_NULLDT_{counter:04d}'
        r['trans_date_trans_time'] = None
        records.append(r)
        counter += 1

    # --- Pattern 4: Unrealistically large amounts (150 records) ---
    for _ in range(250):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_LARGE_{counter:04d}'
        r['amt'] = round(random.uniform(100000, 9999999), 2)
        records.append(r)
        counter += 1

    # --- Pattern 5: Null merchant name (100 records) ---
    for _ in range(200):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_NOMERCH_{counter:04d}'
        r['merchant'] = None
        records.append(r)
        counter += 1

    # --- Pattern 6: Zero amount (100 records) ---
    for _ in range(200):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_ZERO_{counter:04d}'
        r['amt'] = 0.00
        records.append(r)
        counter += 1

    # --- Pattern 7: Invalid category (100 records) ---
    for _ in range(200):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_CAT_{counter:04d}'
        r['category'] = random.choice(['unknown', 'N/A', 'INVALID', '', 'other'])
        records.append(r)
        counter += 1

    # --- Pattern 8: Duplicate trans_num (50 records) ---
    # Reuse same trans_num to simulate duplicates
    for i in range(100):
        r = base_record(counter)
        r['trans_num'] = f'DIRTY_DUP_00{i % 10}'  # only 10 unique IDs = 50 dupes
        records.append(r)
        counter += 1

    return pd.DataFrame(records)


print("Generating dirty records...")
df = generate_dirty_records()
df['dwh_create_date'] = datetime.now()

# Summary before loading
print(f"\nDirty records breakdown:")
print(f"  Negative amounts:       {(df['amt'] < 0).sum()}")
print(f"  Null trans_num:         {df['trans_num'].isna().sum()}")
print(f"  Null date:              {df['trans_date_trans_time'].isna().sum()}")
print(f"  Unrealistic amounts:    {(df['amt'] > 100000).sum()}")
print(f"  Null merchant:          {df['merchant'].isna().sum()}")
print(f"  Zero amounts:           {(df['amt'] == 0).sum()}")
print(f"  Invalid categories:     {(~df['category'].isin(CATEGORIES)).sum()}")
print(f"  Total records:          {len(df)}")

df.to_sql(
    'sparkov_fraud_test',
    engine,
    schema='bronze',
    if_exists='append',
    index=False
)

print(f"\n✅ Injected {len(df)} dirty records into bronze.sparkov_fraud_test")