import pandas as pd
from faker import Faker
import random
from datetime import datetime

fake = Faker()
random.seed(42)

# Step 1 — extract real merchant names from Sparkov
df_sparkov = pd.read_csv('fraudTest.csv')
df_sparkov_train = pd.read_csv('fraudTrain.csv')
combined_df = pd.concat([df_sparkov, df_sparkov_train], ignore_index=True)
unique_merchants = combined_df[['merchant', 'category']].drop_duplicates('merchant')

print(f"Found {len(unique_merchants)} unique merchants in Sparkov")

MERCHANT_TIERS = ['small', 'medium', 'enterprise']
TIER_WEIGHTS = [40, 40, 20]

COMMISSION_RATES = {
    'small':      (2.5, 3.5),
    'medium':     (1.8, 2.5),
    'enterprise': (1.0, 1.8),
}

COUNTRIES = ['US', 'UK', 'Canada', 'Germany', 'France', 'Australia']
COUNTRY_WEIGHTS = [60, 15, 10, 5, 5, 5]

# Step 2 — enrich each real merchant with extra attributes
records = []
for i, row in unique_merchants.iterrows():
    tier = random.choices(MERCHANT_TIERS, weights=TIER_WEIGHTS)[0]
    commission_min, commission_max = COMMISSION_RATES[tier]
    country = random.choices(COUNTRIES, weights=COUNTRY_WEIGHTS)[0]

    records.append({
        'merchant_id':     f'MERCH{i:05d}',
        'merchant_name':   row['merchant'],
        'category':        row['category'],
        'merchant_tier':   tier,
        'country':         country,
        'city':            fake.city(),
        'commission_rate': round(random.uniform(commission_min, commission_max), 2),
        'is_online':       row['category'] in ['misc_net', 'shopping_net'],
        'founded_year':    random.randint(1990, 2020),
        'is_active':       random.choices([True, False], weights=[95, 5])[0],
    })

df_merchants = pd.DataFrame(records)
df_merchants.to_csv('merchants.csv', index=False)
print(f"✅ Done — {len(df_merchants)} merchants saved to merchants.csv")
print(f"\nTier distribution:")
print(df_merchants['merchant_tier'].value_counts())