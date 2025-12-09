/*
===========================================================================
Stored Procedure: gold.load_data_warehouse
purpose:
    - create the tables of gold layer:
		gold.fast_sales
		gold.dim_customer
		gold.dim_product
		gold.dim_geo
		gold.dim_date
	- Performs ELT to populate the tables of the Gold Layer.
  
===========================================================================
*/
CREATE OR ALTER PROCEDURE gold.load_data_warehouse
AS
BEGIN
    SET NOCOUNT ON;
    PRINT '--- Starting Gold Layer Load (dwh_ prefix applied) ---';

    -- ==========================================================
    -- 1. DIMENSION: Customer
    -- ==========================================================
    PRINT 'Loading dim_customer...';
    IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL DROP TABLE gold.dim_customer;
    
    CREATE TABLE gold.dim_customer (
        customer_key INT IDENTITY(1,1) PRIMARY KEY, -- Derived
        customer_id INT,
        customer_segment NVARCHAR(50),
        customer_city NVARCHAR(500),
        customer_state NVARCHAR(500)
    );

    INSERT INTO gold.dim_customer (customer_id, customer_segment, customer_city, customer_state)
    SELECT DISTINCT 
        customer_id, customer_segment, customer_city, customer_state
    FROM silver.kaggle_supply_chain_cleaned
    WHERE customer_id IS NOT NULL;

    -- ==========================================================
    -- 2. DIMENSION: Product
    -- ==========================================================
    PRINT 'Loading dim_product...';
    IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL DROP TABLE gold.dim_product;

    CREATE TABLE gold.dim_product (
        product_key INT IDENTITY(1,1) PRIMARY KEY, -- Derived
        product_card_id INT,
        product_name NVARCHAR(500),
        product_category_name NVARCHAR(100),
        product_department_name NVARCHAR(500),
        product_price DECIMAL(18,2)
    );

    INSERT INTO gold.dim_product (product_card_id, product_name, product_category_name, product_department_name, product_price)
    SELECT DISTINCT 
        product_card_id, product_name, product_category_name, product_department_name, product_price
    FROM silver.kaggle_supply_chain_cleaned
    WHERE product_card_id IS NOT NULL;

    -- ==========================================================
    -- 3. DIMENSION: Geography
    -- ==========================================================
    PRINT 'Loading dim_geography...';
    IF OBJECT_ID('gold.dim_geography', 'U') IS NOT NULL DROP TABLE gold.dim_geography;

    CREATE TABLE gold.dim_geography (
        geo_key INT IDENTITY(1,1) PRIMARY KEY, -- Derived
        order_country NVARCHAR(100),
        order_region NVARCHAR(100),
        order_state NVARCHAR(100),
        order_city NVARCHAR(100),
        market NVARCHAR(50),
        latitude DECIMAL(10,8),
        longitude DECIMAL(11,8)
    );

    INSERT INTO gold.dim_geography (order_country, order_region, order_state, order_city, market, latitude, longitude)
    SELECT DISTINCT 
        order_country, order_region, order_state, order_city, market, latitude, longitude
    FROM silver.kaggle_supply_chain_cleaned;

    -- ==========================================================
    -- 4. DIMENSION: Date
    -- ==========================================================
    PRINT 'Loading dim_date...';
    IF OBJECT_ID('gold.dim_date', 'U') IS NOT NULL DROP TABLE gold.dim_date;

    CREATE TABLE gold.dim_date (
        date_key INT PRIMARY KEY, -- Derived (YYYYMMDD)
        full_date DATE,
        dwh_year INT,                 -- Derived
        dwh_month INT,                -- Derived
        dwh_month_name NVARCHAR(20),  -- Derived
        dwh_quarter INT,              -- Derived
        dwh_year_month NVARCHAR(20),  -- Derived
        dwh_day_of_week NVARCHAR(20)  -- Derived
    );

    WITH AllDates AS (
        SELECT order_date AS date_value FROM silver.kaggle_supply_chain_cleaned
        UNION 
        SELECT shipping_date AS date_value FROM silver.kaggle_supply_chain_cleaned
    )
    INSERT INTO gold.dim_date (date_key, full_date, dwh_year, dwh_month, dwh_month_name, dwh_quarter, dwh_year_month, dwh_day_of_week)
    SELECT DISTINCT 
        CAST(FORMAT(date_value, 'yyyyMMdd') AS INT),
        CAST(date_value AS DATE),
        YEAR(date_value),
        MONTH(date_value),
        LEFT(DATENAME(MONTH, date_value),3),
        DATEPART(QUARTER, date_value),
        FORMAT(date_value, 'yyyy-MMM'),
        LEFT(DATENAME(WEEKDAY, date_value),3)
    FROM AllDates
    WHERE date_value IS NOT NULL;

    -- ==========================================================
    -- 5. FACT TABLE: Supply Chain
    -- ==========================================================
    PRINT 'Loading fact_supply_chain...';
    IF OBJECT_ID('gold.fact_supply_chain', 'U') IS NOT NULL DROP TABLE gold.fact_supply_chain;

    CREATE TABLE gold.fact_supply_chain (
        -- Primary Key (Using original ID as it is unique)
        order_item_id INT PRIMARY KEY,
        
        -- Derived Foreign Keys 
		customer_key INT,
        product_key INT,
        geo_key INT,
        order_date_key INT,
        shipping_date_key INT,

        -- Derived Time Analysis (dwh_)
        dwh_order_hour INT, 

        -- Attributes
        order_id NVARCHAR(50),
        shipping_mode NVARCHAR(50),
        delivery_status NVARCHAR(50),
        order_status NVARCHAR(50),
        payment_type NVARCHAR(50),
        late_delivery_risk NVARCHAR(50),

        -- Metrics
        sales_per_item DECIMAL(18,2),
        sales_per_customer DECIMAL(18,2),
        item_profit DECIMAL(18,2),
        order_item_quantity INT,
        order_item_discount DECIMAL(18,2),
        actual_shipping_days INT,
        scheduled_shipping_days INT,
        dwh_delivery_variance_days INT -- Already named dwh_ in Silver
    );

    INSERT INTO gold.fact_supply_chain (
        order_item_id,
        customer_key, product_key, geo_key, order_date_key, shipping_date_key, dwh_order_hour,
        order_id, shipping_mode, delivery_status, order_status, payment_type, late_delivery_risk,
        sales_per_item, sales_per_customer, item_profit, order_item_quantity, order_item_discount,
        actual_shipping_days, scheduled_shipping_days, dwh_delivery_variance_days
    )
    SELECT 
        s.order_item_id,
        
        -- Lookup Keys
        c.customer_key,
        p.product_key,
        g.geo_key,
        CAST(FORMAT(s.order_date, 'yyyyMMdd') AS INT) AS order_date_key,
        CAST(FORMAT(s.shipping_date, 'yyyyMMdd') AS INT) AS shipping_date_key,
        
        -- Derived Hour
        DATEPART(HOUR, s.order_date) AS dwh_order_hour,

        -- Direct Columns
        s.order_id,
        s.shipping_mode,
        s.delivery_status,
        s.order_status,
        s.payment_type,
        s.late_delivery_risk,
        s.sales_per_item,
        s.sales_per_customer,
        s.item_profit,
        s.order_item_quantity,
        s.order_item_discount,
        s.actual_shipping_days,
        s.scheduled_shipping_days,
        s.dwh_delivery_variance_days

    FROM silver.kaggle_supply_chain_cleaned s
    LEFT JOIN gold.dim_customer c 
        ON s.customer_id = c.customer_id 
        AND s.customer_city = c.customer_city 
        AND s.customer_state = c.customer_state

    -- FIX 2: Join on ID + Attributes to find the specific Product version
    LEFT JOIN gold.dim_product p 
        ON s.product_card_id = p.product_card_id
        AND s.product_name = p.product_name
        AND s.product_price = p.product_price 
        -- (Assuming price change creates a new product row in your logic)

    -- FIX 3: Geography is already joining on all columns, so it is likely safe
    LEFT JOIN gold.dim_geography g 
        ON s.order_city = g.order_city 
        AND s.order_state = g.order_state 
        AND s.order_country = g.order_country
		AND s.latitude = g.latitude
		AND s.longitude = g.longitude

    PRINT '--- Gold Layer Load Complete ---';
END
GO

-- Execute
--EXEC gold.load_data_warehouse;

