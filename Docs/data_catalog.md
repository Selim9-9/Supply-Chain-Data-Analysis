# Data Dictionary
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

Data warehouse: `supply_chain_data_warehouse`  
Schema: `gold`  
Source: `silver.kaggle_supply_chain_cleaned`

---

## Table: `gold.dim_customer`

**Purpose:** Customer dimension containing basic customer attributes for analysis and lookup.  
**Grain:** One row per unique customer (by `customer_id`, `customer_segment`, `customer_city`, `customer_state`).  
**Primary Key:** `customer_key`

| Column           | Data Type          | Key | Description                                                                                  | Source / Derivation                                      |
|------------------|--------------------|-----|----------------------------------------------------------------------------------------------|----------------------------------------------------------|
| `customer_key`   | `INT IDENTITY`     | PK  | Surrogate key for the customer dimension.                                                    | Generated in `dim_customer`.                             |
| `customer_id`    | `INT`              |     | Business/customer identifier from the source system.                                         | `silver.customer_id`                                     |
| `customer_segment` | `NVARCHAR(50)`   |     | Customer segment (e.g., Consumer, Corporate, etc.).                                          | `silver.customer_segment`                                |
| `customer_city`  | `NVARCHAR(500)`    |     | City where the customer is located.                                                          | `silver.customer_city`                                   |
| `customer_state` | `NVARCHAR(500)`    |     | State/region where the customer is located.                                                  | `silver.customer_state`                                  |

---

## Table: `gold.dim_product`

**Purpose:** Product dimension with descriptive attributes used for product‑related analysis.  
**Grain:** One row per unique combination of product (by `product_card_id`, `product_name`, `product_category_name`, `product_department_name`, `product_price`).  
**Primary Key:** `product_key`

| Column                    | Data Type          | Key | Description                                                                                           | Source / Derivation                            |
|---------------------------|--------------------|-----|-------------------------------------------------------------------------------------------------------|----------------------------------------------|
| `product_key`             | `INT IDENTITY`     | PK  | Surrogate key for the product dimension.                                                              | Generated in `dim_product`.                  |
| `product_card_id`         | `INT`              |     | Business product identifier from the source system.                                                   | `silver.product_card_id`                     |
| `product_name`            | `NVARCHAR(500)`    |     | Name/description of the product.                                                                      | `silver.product_name`                        |
| `product_category_name`   | `NVARCHAR(100)`    |     | Product category name (e.g., Electronics, Furniture).                                                 | `silver.product_category_name`               |
| `product_department_name` | `NVARCHAR(500)`    |     | Higher-level department the product belongs to.                                                       | `silver.product_department_name`             |
| `product_price`           | `DECIMAL(18,2)`    |     | Unit price of the product at the time of the order (as modeled).                                     | `silver.product_price`                       |

---

## Table: `gold.dim_geography`

**Purpose:** Geography dimension for analyzing orders by country/region/state/city/market.  
**Grain:** One row per unique combination of `order_country`, `order_region`, `order_state`, `order_city`, `market`, `latitude`, `longitude`.  
**Primary Key:** `geo_key`

| Column         | Data Type        | Key | Description                                                           | Source / Derivation                     |
|----------------|------------------|-----|-----------------------------------------------------------------------|-----------------------------------------|
| `geo_key`      | `INT IDENTITY`   | PK  | Surrogate key for the geography dimension.                            | Generated in `dim_geography`.          |
| `order_country`| `NVARCHAR(100)`  |     | Country where the order is placed/delivered.                          | `silver.order_country`                 |
| `order_region` | `NVARCHAR(100)`  |     | Region within the country (e.g., Western Europe, East of USA).       | `silver.order_region`                  |
| `order_state`  | `NVARCHAR(100)`  |     | State/province/admin area of the order destination.                   | `silver.order_state`                   |
| `order_city`   | `NVARCHAR(100)`  |     | City of the order destination.                                       | `silver.order_city`                    |
| `market`       | `NVARCHAR(50)`   |     | Market grouping (e.g., USCA, Europe, LATAM, Pacific Asia).           | `silver.market`                        |
| `latitude`     | `DECIMAL(9,6)`   |     | Latitude of the city/location (approximate).                          | `CAST(silver.latitude AS DECIMAL(9,6))` |
| `longitude`    | `DECIMAL(9,6)`   |     | Longitude of the city/location (approximate).                         | `CAST(silver.longitude AS DECIMAL(9,6))` |

---

## Table: `gold.dim_date`

**Purpose:** Date dimension used for time‑based analysis (order dates, shipping dates, etc.).  
**Grain:** One row per calendar date present in the source (order or shipping dates).  
**Primary Key:** `date_key`

| Column            | Data Type        | Key | Description                                                                                          | Source / Derivation                                              |
|-------------------|------------------|-----|------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| `date_key`        | `INT`            | PK  | Surrogate integer key in `YYYYMMDD` format for joining to facts.                                    | `CAST(FORMAT(date_value, 'yyyyMMdd') AS INT)`                    |
| `full_date`       | `DATE`           |     | The actual calendar date.                                                                            | `CAST(date_value AS DATE)`                                       |
| `dwh_year`        | `INT`            |     | Calendar year.                                                                                       | `YEAR(date_value)`                                               |
| `dwh_month`       | `INT`            |     | Calendar month number (1–12).                                                                        | `MONTH(date_value)`                                              |
| `dwh_month_name`  | `NVARCHAR(20)`   |     | 3‑letter month abbreviation used for display (e.g., `Jan`, `Feb`).                                  | `LEFT(DATENAME(MONTH, date_value), 3)`                           |
| `dwh_quarter`     | `INT`            |     | Calendar quarter number (1–4).                                                                       | `DATEPART(QUARTER, date_value)`                                  |
| `dwh_year_month`  | `NVARCHAR(20)`   |     | Year and month label (e.g., `2020-Jan`) for reporting and grouping.                                  | `FORMAT(date_value, 'yyyy-MMM')`                                 |
| `dwh_day_of_week` | `NVARCHAR(20)`   |     | 3‑letter day‑of‑week abbreviation (e.g., `Mon`, `Tue`, `Sun`).                                       | `LEFT(DATENAME(WEEKDAY, date_value), 3)`                         |

---

## Table: `gold.fact_supply_chain`

**Purpose:** Central fact table at order‑item level, containing sales, profitability, and logistics metrics.  
**Grain:** **One row per order item** (`order_item_id`).  
**Primary Key:** `order_item_id`  
**Foreign Keys:**  
- `customer_key` → `gold.dim_customer.customer_key`  
- `product_key` → `gold.dim_product.product_key`  
- `geo_key` → `gold.dim_geography.geo_key`  
- `order_date_key` → `gold.dim_date.date_key`  
- `shipping_date_key` → `gold.dim_date.date_key`

| Column                      | Data Type        | Key | Description                                                                                                      | Source / Derivation                                                       |
|-----------------------------|------------------|-----|------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| `order_item_id`             | `INT`            | PK  | Business key identifying a unique order line/item in the source data.                                           | `silver.order_item_id`                                                    |
| `customer_key`              | `INT`            | FK  | Surrogate key to the customer dimension.                                                                        | Lookup via `silver.customer_id`, `customer_city`, `customer_state`.       |
| `product_key`               | `INT`            | FK  | Surrogate key to the product dimension.                                                                         | Lookup via `silver.product_card_id`, `product_name`, `product_price`.     |
| `geo_key`                   | `INT`            | FK  | Surrogate key to the geography dimension.                                                                       | Lookup via `order_country/state/city`, `market`, `latitude`, `longitude`. |
| `order_date_key`            | `INT`            | FK  | Surrogate key to `dim_date` representing the order date.                                                        | `CAST(FORMAT(silver.order_date, 'yyyyMMdd') AS INT)`                      |
| `shipping_date_key`         | `INT`            | FK  | Surrogate key to `dim_date` representing the shipping date.                                                     | `CAST(FORMAT(silver.shipping_date, 'yyyyMMdd') AS INT)`                   |
| `dwh_order_hour`            | `INT`            |     | Hour of the day (0–23) when the order was placed, for intraday analysis.                                       | `DATEPART(HOUR, silver.order_date)`                                       |
| `order_id`                  | `NVARCHAR(50)`   |     | Business order identifier grouping multiple order items into a single order.                                    | `silver.order_id`                                                         |
| `shipping_mode`             | `NVARCHAR(50)`   |     | Shipping mode/service level (e.g., Standard, Express).                                                          | `silver.shipping_mode`                                                    |
| `delivery_status`           | `NVARCHAR(50)`   |     | Status of the delivery (e.g., Delivered, Late).                                                                 | `silver.delivery_status`                                                  |
| `order_status`              | `NVARCHAR(50)`   |     | Status of the order in the sales process (e.g., Completed, Cancelled).                                         | `silver.order_status`                                                     |
| `payment_type`              | `NVARCHAR(50)`   |     | Payment method used (e.g., Credit card, Cash).                                                                  | `silver.payment_type`                                                     |
| `late_delivery_risk`        | `INT`            |     | This is a simple, pre-calculated flag . 1 means the delivery "Was_late". 0 means the delivery "Was_on_time" or early.This column is almost certainly created using a simple rule: IF 'Days for shipping (real)' > 'Days for shipment (scheduled)' THEN 1 ELSE 0                           | `silver.late_delivery_risk`                                               |
| `sales_per_item`            | `DECIMAL(18,2)`  |     | Revenue amount attributed to this order item.                                                                    | `silver.sales_per_item`                                                   |
| `sales_per_customer`        | `DECIMAL(18,2)`  |     | Revenue attributed to the customer for this item/order (as modeled in source).                                   | `silver.sales_per_customer`                                               |
| `item_profit`               | `DECIMAL(18,2)`  |     | Profit amount for this order item.                                                                              | `silver.item_profit`                                                      |
| `order_item_quantity`       | `INT`            |     | Quantity of units for this order item.                                                                          | `silver.order_item_quantity`                                             |
| `order_item_discount`       | `DECIMAL(18,2)`  |     | Discount amount applied to this order item.                                                                     | `silver.order_item_discount`                                             |
| `actual_shipping_days`      | `INT`            |     | Actual number of days between order and delivery (or shipping), depending on original dataset definition.      | `silver.actual_shipping_days`                                            |
| `scheduled_shipping_days`   | `INT`            |     | Planned/scheduled number of shipping days.                                                                      | `silver.scheduled_shipping_days`                                         |
| `dwh_delivery_variance_days`| `INT`            |     | Calculated: actual_shipping_days - scheduled_shipping_days; positive = late, negative = early, 0 = on time.         | `silver.dwh_delivery_variance_days`                                      |

---
