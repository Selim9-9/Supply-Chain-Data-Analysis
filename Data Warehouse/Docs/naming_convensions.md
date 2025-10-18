# **Naming Conventions**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse for the DataCo Supply Chain Analysis Project. These conventions are adapted for our Kaggle-sourced dataset (DataCo Smart Supply Chain for Big Data Analysis), ensuring consistency across the Bronze-Silver-Gold layers while supporting data management, quality assurance, and team collaboration.

### **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure](#stored-procedure-naming-conventions)
---

## **General Principles**

- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to separate words.
- **Language**: Use English for all names.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

## **Table Naming Conventions**

### **Bronze Rules**
**Definition**: The Bronze layer represents the raw, unaltered ingestion of source data from Kaggle, serving as the staging area for initial data loading without any transformations. This ensures data lineage traceability back to the original CSV files (e.g., orders.csv, customers.csv).

- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system. For our Kaggle dataset, use `kaggle`.  
  - `<entity>`: Exact table name from the source system (derived from Kaggle CSV filenames, lowercased and snake_cased).  
  - Example: `kaggle_orders` → Raw orders data from the Kaggle dataset's orders.csv file.

### **Silver Rules**
**Definition**: The Silver layer contains cleaned, validated, and lightly transformed data, ready for business logic application. It maintains traceability to the Bronze layer while handling inconsistencies like missing values and duplicates specific to our supply chain dataset.

- All names must start with the source system name, and table names must match their original names without renaming, but with business-oriented refinements for our project.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system. For our Kaggle dataset, use `kaggle`.  
  - `<entity>`: Exact table name from the source system, refined for consistency (e.g., lowercased and snake_cased from Kaggle CSVs).  
  - Example: `kaggle_customers` → Cleaned customer information from the Kaggle dataset's customers.csv file.

### **Gold Rules**
**Definition**: The Gold layer provides business-ready, aggregated, and denormalized data optimized for analysis, reporting, and querying in our supply chain project. It uses dimensional modeling (e.g., star schema) to support KPIs like delivery performance and cost optimization.

- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**  
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`, tailored to supply chain entities like orders and shipping).  
  - Examples:
    - `dim_customers` → Dimension table for customer data in the supply chain analysis.  
    - `fact_orders` → Fact table containing order transactions and metrics.  

#### **Glossary of Category Patterns**

| Pattern     | Meaning                           | Example(s)                              |
|-------------|-----------------------------------|-----------------------------------------|
| `dim_`      | Dimension table                  | `dim_customer`, `dim_product`           |
| `fact_`     | Fact table                       | `fact_sales`, `fact_orders`             |
| `report_`   | Report table                     | `report_customers`, `report_sales_monthly`   |

## **Column Naming Conventions**

### **Surrogate Keys**  
**Definition**: Surrogate keys are artificial, system-generated unique identifiers (typically integers) used in dimension tables to provide stable references for joins and historical tracking. They are essential in our data warehouse for handling slowly changing dimensions (SCD) in supply chain entities like customers or products, ensuring data integrity without relying on volatile natural keys from the Kaggle source.

- All primary keys in dimension tables must use the suffix `_key`.
- **`<table_name>_key`**  
  - `<table_name>`: Refers to the name of the table or entity the key belongs to.  
  - `_key`: A suffix indicating that this column is a surrogate key.  
  - Example: `customer_key` → Surrogate key in the `dim_customers` table.

### **Technical Columns**
**Definition**: Technical columns are metadata fields added by the data warehouse system to track ETL processes, audit data lineage, and support quality assurance. In our project, they help document transformations from Kaggle raw data through Bronze-Silver-Gold layers, including load timestamps and validation flags for supply chain data integrity.

- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.
- **`dwh_<column_name>`**  
  - `dwh`: Prefix exclusively for system-generated metadata.  
  - `<column_name>`: Descriptive name indicating the column's purpose.  
  - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.
 
## **Stored Procedure**

**Definition**: Stored procedures encapsulate reusable SQL logic for data loading, transformation, and maintenance tasks. In our supply chain project, they automate the ETL pipeline (e.g., ingesting Kaggle CSVs into Bronze, cleaning for Silver, and aggregating for Gold), ensuring reproducibility and efficiency for the team's data management requirements.

- All stored procedures used for loading data must follow the naming pattern:
- **`load_<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example: 
    - `load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `load_silver` → Stored procedure for loading data into the Silver layer.
