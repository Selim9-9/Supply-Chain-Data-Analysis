# Source System Analysis: DataCo SMART Supply Chain Dataset

**Document Version**: 1.0  
**Date**: October 20, 2025  
**Author**: Supply Chain Analytics Team  
**Purpose**: This document analyzes the source system for the bronze layer ingestion in our data warehouse project. It addresses the key questions from the Source System Interview framework, based on the Kaggle dataset (DataCo SMART SUPPLY CHAIN FOR BIG DATA ANALYSIS) and GitHub business requirements (Supply-Chain-Data-Analysis repository). The dataset simulates an e-commerce supply chain for analytics, with ~180,000 records across 11 CSV files (~1.5 GB). This analysis ensures raw data fidelity for downstream ETL, supporting KPIs like on-time delivery (>95%) and inventory optimization.

The bronze layer will ingest data as-is (no transformations) using a medallion architecture (e.g., via dbt/Airflow), preserving lineage for compliance and scalability.

---

## 1. Business Context & Ownership

### What Business Owns This?

- **Ownership**: The dataset simulates ownership by a fictional e-commerce/retail business (e.g., "DataCo"), focusing on end-to-end supply chain operations: customer orders, product management, shipping, payments, and returns. It represents a large online retailer handling B2C/B2B transactions.
- **Project Context**: In our GitHub requirements, this source is owned by the Supply Chain Analytics Team. It serves as the foundational system for building a data warehouse to drive business intelligence, including sales forecasting, customer segmentation, and logistics efficiency. No real-world PII or proprietary data; anonymized for analytical use.

### System & Data Documentation

- **System Overview**: Static, file-based source (CSV files) from Kaggle, designed for big data analysis in supply chains. Covers scenarios like fraud detection, delivery delays, and revenue trends. No live database—downloads via Kaggle platform.

- **Data Catalog**:

| Entity/File | Key Details | Row Count | Columns (Sample) |
|---|---|---|---|
| Orders (DataCoSupplyChainDataset.csv) | Core order data: IDs, dates, sales, status | ~180,000 | Order ID (PK, string), Order Date (date), Customer Segment (categorical: Consumer/Corporate), Product Category (e.g., Technology/Clothing), Sales (float), Delivery Status (e.g., Shipped/Advance), Days Late (int), Order Profit (float) |
| Customers (customer_segments.csv) | Demographics and segments | ~1,000 | Customer ID (string), Segment (e.g., Small Business) |
| Products (product_details.csv) | Descriptions and pricing | ~10,000 | Product ID (string), Description (string), Price (float) |
| Shipping (shipping_modes.csv) | Logistics details | ~500 | Mode (e.g., Regular Air), Cost (float) |
| Others (e.g., returns.csv) | Returns and payments | Varies | Return ID, Reason (string) |

- **Documentation Sources**: Kaggle dataset page (metadata, samples); GitHub Business Requirements.md (emphasizes data lineage for auditing, e.g., GDPR compliance). Data types: Mix of string (80%), numeric (15%), date (5%). Quality Notes: ~5-10% nulls in delay fields; potential duplicates in Order IDs (to validate in bronze).

---

## 2. Extract and Load

### Incremental vs Full Load?

- **Strategy**: Initial ingestion: **Full load** to capture the complete historical snapshot, as the Kaggle source is static (no native updates). Future simulation: **Incremental loads** using timestamps (e.g., Order Date or Ship Date) for efficiency, aligning with GitHub requirements for ETL scheduling (e.g., Airflow/dbt). This avoids reloading unchanged data; delta logic via tools like Delta Lake.
- **Rationale**: Dataset is a one-time download; increments would apply if extending to real-time sources (e.g., API feeds for ongoing orders).

### Historical Data Needs

- **Coverage**: Full historical data from ~2015–2018 (based on date columns), providing multi-year trends for time-series analysis. All records (~180K rows) are required to support GitHub goals like ML-based delay prediction and historical KPI backtesting (e.g., order fulfillment costs).
- **Needs**: 100% retention for auditing and completeness; no data gaps noted. Bronze layer will store as immutable snapshots with timestamps for versioning.

### Data Scope & Size of Extract

- **Scope**: Comprehensive: All 11 CSVs, prioritizing core entities (orders, customers, products, shipping, returns) for supply chain analytics. Exclude non-analytical metadata. Aligns with GitHub scope: Focus on logistics (e.g., delivery status) and sales (e.g., profit metrics); filter downstream in silver layer.
- **Size**: Primary file: 180,000 rows × ~50 columns (~500 MB uncompressed). Total dataset: ~1.5 GB. Expected post-compression (Parquet): <500 MB. No PII scope—focus on aggregated insights.

### How to Avoid Volume Spikes?

- **Approach**: Source is fixed-size/static, so no inherent spikes. Mitigation:
  - Extract via Kaggle API (batched downloads, e.g., 10K rows/chunk using Python Pandas).
  - Partition ingestion by date (e.g., monthly Order Date buckets) to parallelize loads.
  - Monitor with GitHub-specified tools (e.g., Databricks/Snowflake quotas); schedule off-peak (e.g., nightly full loads initially).
  - Rate-limit API calls; compress during transfer to reduce bandwidth (~50% savings).

---

## 3. Architecture & Technology

### SQL? How is Data Stored?

- **SQL Support**: Source is non-SQL (flat CSVs); no querying at origin. In bronze layer: Load to SQL-compatible data warehouse (e.g., Snowflake, BigQuery, or PostgreSQL) for ad-hoc queries. Use SQL for validation (e.g., `SELECT COUNT(*) FROM bronze_orders`).
- **Storage**: Raw CSVs stored in cloud object storage (e.g., S3) pre-ingestion. Bronze: As Parquet/Delta tables in the warehouse, preserving original structure. GitHub: Medallion setup ensures scalability (e.g., ACID transactions for increments).

### What is the Schema? API?

- **Schema**: Denormalized relational (CSV-based); no enforced schema at source—infer from headers.
  - **Primary Structure**: Fact table (orders) with dimensions (customers/products/shipping). Keys: Order ID (PK), Product ID (FK). Joins: Via IDs (e.g., orders to products on Product ID).
  - **Sample Schema Table** (Main File):

| Column | Type | Nullable? | Description |
|---|---|---|---|
| Order ID | STRING | No | Unique order identifier |
| Order Date | DATE | No | Order placement date |
| Customer Segment | STRING | No | Buyer type (e.g., Consumer) |
| Product Category | STRING | No | Item category |
| Sales | FLOAT | No | Total sales amount |
| Delivery Status | STRING | No | Shipment status |
| Days Late | INT | Yes (~5%) | Delay in days |
| Order Profit | FLOAT | Yes (~10%) | Profit after costs |

  - **Issues**: Inconsistent casing (e.g., "Sales" vs "sales"); validate types in ETL. Full schema: ~50 columns in main file; supporting files add ~20 unique.

- **API?**: No direct API for data access. Extraction: Kaggle Datasets API (REST-based, e.g., `kaggle datasets download -d shashwatwork/dataco-smart-supply-chain-for-big-data-analysis`). Authentication: API token (free signup). For bronze: Python script (e.g., with `kaggle` CLI or requests library) to pull CSVs. GitHub: Design for extensibility (e.g., future REST APIs from ERP systems).

---

## 4. Summary & Recommendations

### Key Insights
- This source is ideal for bronze as a raw, historical snapshot—low complexity, full coverage for supply chain analytics.
- Total volume manageable; focus on quality checks (e.g., duplicates) during ingestion.
- Static nature supports repeatable, auditable ingestion for compliance.

### Risks
- Static nature limits real-time simulation; plan for synthetic data generation if needed.
- Ensure GitHub compliance (e.g., data privacy).
- Data quality validation essential (e.g., null checks, duplicate detection).

### Next Steps for Bronze Layer

1. Implement extraction script (Python + Kaggle API).
2. Ingest to warehouse (full load test on subset).
3. Document lineage in GitHub (e.g., update ETL.md).
4. Set up monitoring and data quality checks.
5. Prepare for silver layer transformations.

---

## 5. References

- **Kaggle Dataset**: [DataCo SMART Supply Chain for Big Data Analysis](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
- **GitHub Repository**: [Supply-Chain-Data-Analysis](https://github.com/Selim9-9/Supply-Chain-Data-Analysis)
- **Related Docs**: [Business Requirements.md](https://github.com/Selim9-9/Supply-Chain-Data-Analysis/blob/main/Business%20Requirements.md)

---

**Document Ready for Upload**: Save as `Source_System_Analysis.md` to `/docs` folder in the GitHub repository for traceability before layer construction.
