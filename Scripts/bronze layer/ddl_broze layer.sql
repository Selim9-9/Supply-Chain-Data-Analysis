/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
-- =====================================================
-- DataCo Smart Supply Chain - Bronze Layer DDL
-- SQL Server Script
-- Convention: snake_case, lowercase
-- Datetime: DATETIME2 (unlimited precision)
-- Nullability: All columns nullable by default
-- Source: Kaggle DataCo Supply Chain Dataset
-- =====================================================

-- Step 1: Drop existing table if it exists
IF OBJECT_ID('bronze.kaggle_supply_chain_raw', 'U') IS NOT NULL
    DROP TABLE bronze.kaggle_supply_chain_raw;
GO

-- Step 2: Create new table with source columns in EXACT order of source sheet
CREATE TABLE bronze.kaggle_supply_chain_raw
(
    -- Columns in the EXACT order from the source sheet
    type NVARCHAR(50),                     -- Type
    days_for_shipping_real INT,            -- Days for shipping (real)
    days_for_shipment_scheduled INT,       -- Days for shipment (scheduled)
    benefit_per_order DECIMAL(18, 4),      -- Benefit per order
    sales_per_customer DECIMAL(18, 4),     -- Sales per customer
    delivery_status NVARCHAR(50),          -- Delivery Status
    late_delivery_risk INT,                -- Late_delivery_risk
    category_id NVARCHAR(50),              -- Category Id
    category_name NVARCHAR(150),           -- Category Name
    customer_city NVARCHAR(100),           -- Customer City
    customer_country NVARCHAR(100),        -- Customer Country
    customer_email NVARCHAR(255),          -- Customer Email
    customer_fname NVARCHAR(100),          -- Customer Fname
    customer_id NVARCHAR(50),              -- Customer Id
    customer_lname NVARCHAR(100),          -- Customer Lname
    customer_password NVARCHAR(255),       -- Customer Password
    customer_segment NVARCHAR(50),         -- Customer Segment
    customer_state NVARCHAR(50),           -- Customer State
    customer_street NVARCHAR(255),         -- Customer Street
    customer_zipcode NVARCHAR(20),         -- Customer Zipcode
    department_id NVARCHAR(50),            -- Department Id
    department_name NVARCHAR(150),         -- Department Name
    latitude DECIMAL(10, 8),               -- Latitude
    longitude DECIMAL(11, 8),              -- Longitude
    market NVARCHAR(100),                  -- Market
    order_city NVARCHAR(100),              -- Order City
    order_country NVARCHAR(100),           -- Order Country
    order_customer_id NVARCHAR(50),        -- Order Customer Id
    order_date DATETIME2,                  -- order date (DateOrders)
    order_id NVARCHAR(50),                 -- Order Id
    order_item_cardprod_id NVARCHAR(50),   -- Order Item Cardprod Id
    order_item_discount DECIMAL(18, 4),    -- Order Item Discount
    order_item_discount_rate DECIMAL(5, 4),-- Order Item Discount Rate
    order_item_id NVARCHAR(50),            -- Order Item Id
    order_item_product_price DECIMAL(18, 4),-- Order Item Product Price
    order_item_profit_ratio DECIMAL(5, 4), -- Order Item Profit Ratio
    order_item_quantity INT,               -- Order Item Quantity
    sales DECIMAL(18, 4),                  -- Sales
    order_item_total DECIMAL(18, 4),       -- Order Item Total
    order_profit_per_order DECIMAL(18, 4), -- Order Profit Per Order
    order_region NVARCHAR(100),            -- Order Region
    order_state NVARCHAR(50),              -- Order State
    order_status NVARCHAR(50),             -- Order Status
    order_zipcode NVARCHAR(20),            -- Order Zipcode
    product_card_id NVARCHAR(50),          -- Product Card Id
    product_category_id NVARCHAR(50),      -- Product Category Id
    product_description NVARCHAR(500),     -- Product Description
    product_image NVARCHAR(500),           -- Product Image
    product_name NVARCHAR(255),            -- Product Name
    product_price DECIMAL(18, 4),          -- Product Price
    product_status NVARCHAR(50),           -- Product Status
    shipping_date DATETIME2,               -- shipping date (DateOrders)
    shipping_mode NVARCHAR(100)            -- Shipping Mode
);
GO


--Creating the second table of customer webpages views:
-- Step 1: Drop existing table if it exists
If OBJECT_ID('bronze.kaggle_tokenized_access_logs','U') IS NOT NULL
	Drop Table bronze.kaggle_tokenized_access_logs;
GO
--Step 2: Create the Table
CREATE TABLE bronze.kaggle_tokenized_access_logs(

	product NVARCHAR(255),
	category NVARCHAR(150),
	date DATETIME2,
	month VARCHAR(4),
	hour INT,
	department NVARCHAR(20),
	ip VARCHAR(50),
	url NVARCHAR(2000)

);
GO



