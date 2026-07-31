<p align="right">
  <a href="README.pt-BR.md">🇧🇷 Português</a> |
  <strong>🇺🇸 English</strong>
</p>

# Olist E-commerce Analytics Engineering Project

Heyo, I was looking for a way to learn more about BigQuery and dbt, so I started building this project using the Brazilian Olist
e-commerce dataset from Kaggle. The project transforms raw data into documented, tested, and analytics-ready models.

The main goal is to learn and design a reliable data pipeline that supports analysis of 
orders, customers, sellers, products, payments, reviews, delivery performance,
and revenue.

> **Project status:** In development. The Bronze, Staging, Intermediate, Marts and Business Metrics layers are all
> complete, Power BI dashboards are currently being built.

## Project Objectives

- Build a layered ELT pipeline following the Medallion Architecture.
- Preserve raw source data before applying transformations.
- Standardize data types, text fields, timestamps, and business keys.
- Resolve source-data issues such as duplicated geolocation records.
- Control model grain and join cardinality to prevent fanout.
- Create reusable intermediate models for downstream analytics.
- Build dimensional marts for business intelligence and reporting.
- Apply automated data quality tests and model documentation with dbt.

## Dataset

The project uses the
[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce),
which contains approximately 100,000 orders placed between 2016 and 2018.

The source includes data about:

- customers;
- orders and order items;
- products and product categories;
- sellers;
- payments;
- customer reviews;
- geolocation.

## Architecture

```mermaid
flowchart TD
    A["Olist CSV files"] --> B["Bronze<br/>Raw BigQuery tables"]
    B --> C["Silver — Staging<br/>Cleaned source-aligned models"]
    C --> D["Silver — Intermediate<br/>Deduplicated, aggregated, and enriched models"]
    D --> E["Gold — Marts<br/>Facts, dimensions, and business metrics"]
    E --> F["BI and analytical use cases"]
```

### Bronze

The raw CSV files are loaded into BigQuery without business transformations.
This layer preserves the original source data and provides a traceable starting
point for the pipeline.

### Silver — Staging

Each source table has a corresponding staging model. This layer:

- casts columns to appropriate BigQuery data types;
- standardizes column names;
- trims and normalizes text values;
- removes accents from city names;
- validates accepted values and required fields;
- keeps transformations close to the source.

### Silver — Intermediate

Intermediate models combine, deduplicate, aggregate, and enrich staging data
before it is consumed by the analytical layer.

Examples include:

- consolidating geolocation to one row per ZIP code prefix;
- enriching customers and sellers with geographic coordinates;
- translating product categories;
- aggregating item and payment metrics at order grain;
- deduplicating order reviews;
- creating an enriched order-level dataset.

### Gold — Marts

The Gold layer will expose business-oriented fact and dimension models for
analytics and BI. It will support topics such as revenue, order volume,
customer behavior, seller performance, product performance, payment methods,
reviews, freight, and delivery performance.

## Data Modeling Principles

The project follows a few core modeling rules:

- Every model has an explicitly defined grain.
- Joins are validated before implementation.
- One-to-many relationships are aggregated before joining to order-level models.
- `LEFT JOIN` is used when unmatched source records must be preserved.
- Known source-data limitations are documented instead of hidden.
- `DISTINCT` is not used as a shortcut to conceal fanout or modeling errors.
- Reusable transformations are separated from business-facing marts.

## Repository Structure

```text
olist_ecom/
├── README.md
├── .gitignore
├── powerbi/
└── dbt_olist/
    ├── dbt_project.yml
    ├── packages.yml
    ├── assets/
    ├── models/
    │   ├── staging/
    │   ├── intermediate/
    │   │   ├── intermediate__models.yml
    │   │   ├── customers/
    │   │   ├── geolocation/
    │   │   ├── orders/
    │   │   ├── products/
    │   │   └── sellers/
    │   └── marts/
    │       ├── dimensions/
    │       └── facts/
    │       └── dataviz/    
    ├── macros/
    ├── seeds/
    ├── snapshots/
    └── tests/
```

Generated folders such as `target/`, `logs/`, and `dbt_packages/` are excluded
from version control.

## Data Lineage

The lineage below shows the data flow from the raw BigQuery sources through the Staging and Intermediate layers to the Gold marts and analytical models.

![dbt data lineage](dbt_olist/assets/dbt-lineage.png)

## Data Quality

Data quality is enforced through dbt tests and validation queries. Current
checks include:

- uniqueness and non-null tests for model keys;
- accepted-value tests for Brazilian state codes and categorical fields;
- relationship and cardinality validation before joins;
- comparison of row counts before and after transformations;
- grain validation using total and distinct key counts;
- explicit validation of expected nullable fields;
- checks for partially missing coordinate pairs.

## Tech Stack

- **Data warehouse:** Google BigQuery
- **Transformation:** dbt
- **Language:** SQL
- **Version control:** Git and GitHub
- **Source data:** CSV files from Kaggle
- **Planned analytics layer:** Power BI

## Running the Project

### Prerequisites

- Access to BigQuery enabled
- A configured dbt profile
- The Olist source tables from kaggle loaded into the Bronze dataset

### Install dependencies

```bash
dbt deps
```

### Validate the connection

```bash
dbt debug
```

### Build the project

```bash
dbt build
```

To build a specific model and its tests:

```bash
dbt build --select model_name
```

## Roadmap

- [x] Load the raw Olist datasets into BigQuery
- [x] Build and test the Staging layer
- [x] Complete the Intermediate layer
- [x] Build dimensional facts and dimensions
- [x] Add business-level metrics and analyses
- [ ] Build a Power BI dashboard
- [ ] Add final architecture and lineage documentation
