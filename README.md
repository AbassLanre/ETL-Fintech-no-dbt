# Fintech Fraud Data Warehouse

This project is a dimensional data warehouse for approximately 1.85 million payment transactions from the Sparkov fraud dataset, built end-to-end in PostgreSQL using the medallion architecture (bronze, silver, gold). Synthetic dirty-data injection is used to demonstrate the cleansing and quarantine pipeline. Fraud detection is a major concern in modern payments, and having clean, well-modelled data is essential whether the warehouse feeds analytics dashboards or downstream AI/ML fraud-detection models. v1 uses Python, Faker, and PostgreSQL. Future phases (see Roadmap) will add dbt for transformation management, Airflow for orchestration, and Docker for environment portability.

## Architecture

## Data Sources

- **Sparkov fraud dataset** — [kaggle.com/datasets/kartik2112/fraud-detection](https://www.kaggle.com/datasets/kartik2112/fraud-detection) (train and test data, ~1.85M rows)
- **Python-generated merchants** — extracts the merchant names from the original Sparkov dataset and enriches each with additional attributes (tier, country, commission rate, online flag, etc.) not present in the source
- **Python-injected dirty data** — the original dataset is mostly clean, so synthetic dirty rows (negatives, nulls, duplicates, invalid categories, unrealistic amounts) are injected to exercise the silver cleansing and quarantine logic

## Medallion Layers

### Bronze

Data from the train, test and injected dirty datasets is loaded here as-is from source. No transformations applied at this layer.

### Silver

Cleansing layer over bronze, including:

- dedup via `row_number()`
- NULL filters
- business rules (e.g. `amt` between 0.01 and 1,000,000)
- standardisation of empty categories to `'unknown'`
- derived columns (`customer_age`, `day_of_week`, haversine distance)
- rejected rows are routed to `silver.sparkov_fraud_test_drop` (quarantine) using the inverse predicate of the keep query, so clean + dropped reconciles back to bronze

### Gold

Star schema (silver separated into dimensions and a fact):

- date dimension
- location dimension
- customer dimension
- merchant dimension
- transaction fact

## Key Engineering Decisions

- The medallion architecture was used as it helps to improve the structure and quality of the warehouse
- PostgreSQL was used instead of Microsoft SQL as it is industry standard in modern data engineering and widely used in UK fintech
- `dim_date` was created from a normal calendar from 2018-2025 so we get a complete timeline of transactions and can answer questions the fact table alone cannot answer
- `date_key` `YYYYMMDD` was used instead of a surrogate key to make visualisation easier (e.g. `20220721`)
- Star schema was used as it balances query speed, storage cost and maintenance
- Facts were made as tables to protect against heavy computation which if left as views could negatively affect query performance; dims were made as views as it makes changing specific descriptive attributes easier during iteration

## Data Quality Validation

Inline table

---

Anti-join result

---

## Findings

## How to Run

## Project Structure

## Roadmap

- **v1:** raw PostgreSQL
- **v2:** dbt port
- **v3:** Airflow orchestration
- **v4:** containerised
