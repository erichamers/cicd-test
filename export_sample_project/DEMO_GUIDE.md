# Pharmaceutical Drug Shipments - Cortex Code Demo Guide

## Use Case Description

A specialty pharmaceutical company needs to track and analyze drug shipments from distribution warehouses to healthcare facilities (hospitals, specialty pharmacies) across the United States. The analytics platform provides supply chain visibility, supports demand forecasting, ensures regulatory compliance, and surfaces operational inefficiencies.

## Business Problem

The commercial operations team lacks answers to critical supply chain questions:

1. **Volume Analysis** -- Which products have the highest shipment volume by region?
2. **Fulfillment Performance** -- Are there delivery delays at specific warehouses?
3. **Customer Health** -- Which customers show declining order patterns (churn risk)?
4. **Compliance Tracking** -- Are controlled substance shipments within regulatory limits?
5. **Revenue Attribution** -- What is the revenue breakdown by therapeutic area and geography?

---

## Data Model Architecture

```
Seeds (raw CSV) --> Staging (views) --> Intermediate (ephemeral) --> Marts (tables)
```

### Layer Responsibilities

| Layer | Materialization | Purpose |
|-------|----------------|---------|
| Seeds | Table (auto) | Load synthetic source data into Snowflake |
| Staging | View | Type casting, renaming, basic cleaning |
| Intermediate | Ephemeral | Business logic joins, calculations |
| Marts | Table | Dimensional model for analytics consumption |

### Entity Relationships

- `raw_shipments` (1) --> (many) `raw_shipment_items` -- via shipment_id
- `raw_shipment_items` (many) --> (1) `raw_products` -- via product_id
- `raw_shipments` (many) --> (1) `raw_customers` -- via customer_id
- `raw_shipments` (many) --> (1) `raw_warehouses` -- via warehouse_id

---

## Seed Files Summary

| File | Rows | Description |
|------|------|-------------|
| raw_products.csv | 15 | Pharmaceutical product catalog |
| raw_customers.csv | 20 | Healthcare facilities across US |
| raw_warehouses.csv | 5 | Distribution centers |
| raw_shipments.csv | 50 | Shipment headers (Jan-Jun 2024) |
| raw_shipment_items.csv | 106 | Line items with lot tracking |

---

## Models Overview

### Staging Layer (5 models)
- `stg_products` -- Product master with explicit types
- `stg_customers` -- Customer data with region classification
- `stg_warehouses` -- Warehouse reference data
- `stg_shipments` -- Shipment headers with status normalization
- `stg_shipment_items` -- Line items with quantity and lot info

### Intermediate Layer (2 models)
- `int_shipments_enriched` -- Shipments joined with customer/warehouse context + fulfillment metrics
- `int_shipment_items_enriched` -- Line items joined with product data + calculated revenue

### Marts Layer (5 models)
- `dim_products` -- Product dimension with price tier
- `dim_customers` -- Customer dimension with geography
- `dim_warehouses` -- Warehouse dimension with capacity tier
- `fct_shipments` -- Fact table at shipment grain with aggregated line-item metrics
- `mart_shipment_summary` -- Pre-aggregated analytics by month/product/region

---

## Tests Included

### Generic Tests (in schema.yml)
- `unique` + `not_null` on all primary/surrogate keys
- `accepted_values` on status fields, regions, therapeutic areas
- `relationships` validating foreign key integrity

### Singular Tests (in tests/)
- `assert_shipment_quantity_positive` -- No zero/negative quantities
- `assert_shipment_date_not_future` -- No future-dated orders
- `assert_controlled_substance_quantity_limit` -- DEA compliance (max 100 units per line)
- `assert_no_expired_product_shipped` -- No dispatch of expired drugs

---

## Demo Walkthrough Script

### Phase 1: Project Setup (2 min)
Show the empty project, explain the business context, run `dbt seed` to load data.

### Phase 2: Staging Layer with Cortex Code (5 min)
Use prompts to generate staging models and demonstrate how Cortex Code:
- Creates properly structured SQL with CTEs
- Applies correct type casting for Snowflake
- Generates schema.yml documentation automatically

### Phase 3: Business Logic Layer (4 min)
Ask Cortex Code to build intermediate models with joins and calculations.

### Phase 4: Dimensional Model (5 min)
Request fact and dimension tables, show surrogate key generation, fulfillment tier logic.

### Phase 5: Testing and Quality (3 min)
Demonstrate test generation -- both generic and custom pharmaceutical business rules.

### Phase 6: Run and Validate (2 min)
Execute `dbt run` + `dbt test`, query the mart to show final business output.

---

## Example Cortex Code Prompts

### Model Generation
1. "Create a staging model for raw_shipments that casts types, trims strings, and normalizes the status field to uppercase"
2. "Build an intermediate model that joins shipments with customer and warehouse data, and calculates days_to_ship and days_in_transit"
3. "Create a fact table for shipments at the header grain with aggregated line-item metrics like total_units and total_revenue"
4. "Generate a mart_shipment_summary model that aggregates by month, product, region, and warehouse"

### Documentation
5. "Generate schema.yml for the staging layer with column descriptions and appropriate dbt generic tests"
6. "Add documentation to fct_shipments explaining the grain, business rules, and column derivations"

### Testing
7. "Add dbt tests to validate referential integrity between fct_shipments and all dimension tables"
8. "Create a custom test that ensures no controlled substance shipments exceed 100 units per line item"
9. "Suggest data quality checks appropriate for a pharmaceutical supply chain pipeline"

### Review and Improvement
10. "Review this model for performance issues and suggest improvements for Snowflake"
11. "What risks or gaps do you see in this data model design?"
12. "Refactor this SQL to follow dbt best practices with CTEs, meaningful aliases, and consistent formatting"
13. "Add incremental materialization logic to fct_shipments using order_date as the partition key"

### Advanced
14. "Create a model that flags shipments at risk of regulatory non-compliance (expired lots, quantity limits)"
15. "Generate a customer churn risk model based on declining shipment frequency over the last 3 months"

---

## Recommendations to Make the Demo More Impactful

1. **Start from scratch** -- Begin with only the seed files and build up iteratively using Cortex Code prompts. This shows the acceleration clearly.

2. **Show the "wrong" version first** -- Write a naive query without CTEs or tests, then ask Cortex Code to improve it. The before/after contrast is compelling.

3. **Highlight pharma-specific concerns** -- Emphasize controlled substance tracking, lot traceability, and expiration date validation. These resonate with pharma stakeholders.

4. **Use `dbt docs serve`** -- Show the generated documentation and DAG lineage graph. Visual impact matters in demos.

5. **Query the final mart** -- End with a simple `SELECT * FROM mart_shipment_summary WHERE therapeutic_area = 'Oncology'` to show tangible business output.

6. **Time the demo** -- Track how long each phase takes. Quote "X minutes to build what would normally take Y hours" to quantify productivity gains.

7. **Leave deliberate gaps** -- Intentionally omit a test or model, then show how Cortex Code can identify the missing piece when asked to review.

---

## Business Value Statement

> This demo demonstrates how Cortex Code reduces the time to build production-ready pharmaceutical data pipelines from days to hours. By automating model generation, test creation, and documentation -- while enforcing dbt best practices and surfacing pharma-specific compliance risks -- engineering teams can deliver analytics faster, with fewer defects, and with built-in regulatory safeguards. For a pharmaceutical company managing specialty drug distribution, this translates directly to faster time-to-insight for commercial operations, reduced compliance risk, and lower cost of data engineering delivery.

---

## Running This Project

```bash
# Load seed data into Snowflake
dbt seed

# Build all models
dbt run

# Execute all tests
dbt test

# Generate documentation
dbt docs generate

# Serve documentation locally (optional)
dbt docs serve
```

Or deploy natively as a dbt Project in Snowflake:
```sql
-- From Snowflake worksheet
CREATE OR REPLACE DATABASE PHARMA_DEMO;
CREATE OR REPLACE SCHEMA PHARMA_DEMO.DBT_DEV;

-- Deploy via snow CLI or Snowsight dbt Project UI
```
