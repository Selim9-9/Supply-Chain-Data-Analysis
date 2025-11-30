

/*
===============================================================================
DDL Script: Create Silver Table - kaggle_supply_chain_cleaned
===============================================================================
Script Purpose:
    - Creates the primary Silver layer table for Supply Chain Analytics.
    - Columns are organized by analytical function to align with project goals.
    - Uses a clean, standardized snake_case naming convention.
    - This structure is designed for the 'INSERT then UPDATE/DELETE' ETL approach.

What new modifications made for this create table:
	- deleted PII and non-important columns
	- renaming some columns arranging them

Next Steps in the Workflow:
    1. INSERT raw data from the Bronze table, renaming columns on the fly.
    2. UPDATE this table to standardize text (trim, case).
    3. UPDATE to handle inconsistencies and impute NULLs.
    4. DELETE invalid rows.
    5. UPDATE to populate the 'Derived Columns' section.
===============================================================================
*/

-- Ensure a clean slate by dropping the table if it already exists
IF OBJECT_ID('silver.kaggle_supply_chain_cleaned', 'U') IS NOT NULL
    DROP TABLE silver.kaggle_supply_chain_cleaned;
GO

CREATE TABLE silver.kaggle_supply_chain_cleaned
(
    -- --------------------------------------------------------------------------
    -- CORE IDENTIFIERS (Defines the grain of the table)
    -- --------------------------------------------------------------------------
    order_item_id NVARCHAR(50),             -- Original: [Order Item Id]
    order_id NVARCHAR(50),                  -- Original: [Order Id]

    -- --------------------------------------------------------------------------
    -- FINANCIAL PERFORMANCE COLUMNS
    -- --------------------------------------------------------------------------
    sales_per_item DECIMAL(18, 4),          -- Original: [Order Item Total] (Renamed for clarity)
    item_profit DECIMAL(18, 4),             -- Original: [Order Profit Per Order] (Renamed for clarity)
    item_profit_ratio DECIMAL(5, 4),        -- Original: [Order Item Profit Ratio]
    sales_per_customer DECIMAL(18, 4),      -- Original: [Sales per customer]
    order_item_discount DECIMAL(18, 4),     -- Original: [Order Item Discount]
    order_item_discount_rate DECIMAL(5, 4), -- Original: [Order Item Discount Rate]
    order_item_quantity INT,                -- Original: [Order Item Quantity]
    product_price DECIMAL(18, 4),           -- Original: [Product Price]

    -- --------------------------------------------------------------------------
    -- LOGISTICS & DELIVERY COLUMNS
    -- --------------------------------------------------------------------------
    shipping_date DATETIME2,                -- Original: [shipping date (DateOrders)]
    actual_shipping_days INT,               -- Original: [Days for shipping (real)]
    scheduled_shipping_days INT,            -- Original: [Days for shipment (scheduled)]
    delivery_status NVARCHAR(50),           -- Original: [Delivery Status]
    late_delivery_risk INT,                 -- Original: [Late_delivery_risk]
    shipping_mode NVARCHAR(100),            -- Original: [Shipping Mode]

    -- --------------------------------------------------------------------------
    -- ORDER & CUSTOMER COLUMNS
    -- --------------------------------------------------------------------------
    order_date DATETIME2,                   -- Original: [order date (DateOrders)]
    order_status NVARCHAR(50),              -- Original: [Order Status]
    payment_type NVARCHAR(50),              -- Original: [Type]
    customer_id NVARCHAR(50),               -- Original: [Order Customer Id] (Chosen over Customer Id)
    customer_segment NVARCHAR(50),          -- Original: [Customer Segment]

    -- --------------------------------------------------------------------------
    -- PRODUCT COLUMNS
    -- --------------------------------------------------------------------------
    product_card_id NVARCHAR(50),           -- Original: [Order Item Cardprod Id] (Chosen over Product Card Id)
    product_name NVARCHAR(255),             -- Original: [Product Name]
    product_category_name NVARCHAR(150),    -- Original: [Category Name]
    product_department_name NVARCHAR(150),  -- Original: [Department Name]
    product_category_id NVARCHAR(50),       -- Original: [Product Category Id]
    department_id NVARCHAR(50),             -- Original: [Department Id]

    -- --------------------------------------------------------------------------
    -- GEOGRAPHIC COLUMNS
    -- --------------------------------------------------------------------------
    order_city NVARCHAR(100),               -- Original: [Order City]
    order_state NVARCHAR(50),               -- Original: [Order State]
    order_country NVARCHAR(100),            -- Original: [Order Country]
    order_region NVARCHAR(100),             -- Original: [Order Region]
    market NVARCHAR(100),                   -- Original: [Market]
    customer_city NVARCHAR(100),            -- Original: [Customer City]
    customer_state NVARCHAR(50),            -- Original: [Customer State]
    --customer_country NVARCHAR(100),         -- Original: [Customer Country]
    latitude DECIMAL(10, 8),                -- Original: [Latitude]
    longitude DECIMAL(11, 8),               -- Original: [Longitude]

    -- --------------------------------------------------------------------------
    -- DERIVED COLUMNS (To be populated via UPDATE statements)
    -- --------------------------------------------------------------------------
    dwh_delivery_variance_days INT NULL,        -- Calculated: [actual_shipping_days] - [scheduled_shipping_days]
	dwh_create_date DATETIME2 DEFAULT GETDATE() -- Calculated: date of table creation for debugging

);
GO

PRINT 'SUCCESS: silver.kaggle_supply_chain_cleaned table has been created.';
