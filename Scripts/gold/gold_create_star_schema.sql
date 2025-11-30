/*
===============================================================================
Procedure: gold.create_star_schema
Purpose:   Builds a full star schema from the Silver data. It creates four
           dimension tables and one central fact table, then adds the primary
           and foreign key relationships.

Data Model:
    - Dimensions: dim_customer, dim_product, dim_shipping_location, dim_date
    - Fact Table: fact_sales_item

Usage Example: EXEC gold.create_star_schema
===============================================================================
*/
CREATE OR ALTER PROCEDURE gold.create_star_schema
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Starting the creation of the Gold Star Schema...';

    --------------------------------------------------------------------------
    -- PART 1: Create the Dimension Tables
    -- These tables hold the descriptive attributes. We use SELECT DISTINCT
    -- to ensure there is only one row for each unique customer, product, etc.
    --------------------------------------------------------------------------
    PRINT ' -> Part 1: Creating Dimension tables...';

    -- Dimension 1: Customers
    DROP TABLE IF EXISTS gold.dim_customer;
    SELECT
        customer_id AS customer_key, -- The primary key for this dimension
        customer_segment,
        customer_state
    INTO gold.dim_customer
    FROM silver.kaggle_supply_chain_cleaned
    GROUP BY customer_id, customer_segment, customer_state;
    PRINT '    -> gold.dim_customer created.';

    -- Dimension 2: Products
    DROP TABLE IF EXISTS gold.dim_product;
    SELECT
        product_id AS product_key, -- The primary key for this dimension
        product_name,
        product_category_name,
        product_department_name,
        product_price
    INTO gold.dim_product
    FROM silver.kaggle_supply_chain_cleaned
    GROUP BY product_id, product_name, product_category_name, product_department_name, product_price;
    PRINT '    -> gold.dim_product created.';

    -- Dimension 3: Shipping Locations
    DROP TABLE IF EXISTS gold.dim_shipping_location;
    SELECT
        -- Since there's no single ID for a location, we create one using IDENTITY.
        -- This is called a "Surrogate Key".
        IDENTITY(INT, 1, 1) AS location_key,
        order_city,
        order_country,
        order_region,
        market
    INTO gold.dim_shipping_location
    FROM silver.kaggle_supply_chain_cleaned
    GROUP BY order_city, order_country, order_region, market;
    PRINT '    -> gold.dim_shipping_location created.';

    -- Dimension 4: Dates
    DROP TABLE IF EXISTS gold.dim_date;
    SELECT
        order_date AS date_key, -- The primary key is the date itself
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        DAY(order_date) AS day,
        DATENAME(weekday, order_date) AS day_of_week
    INTO gold.dim_date
    FROM silver.kaggle_supply_chain_cleaned
    GROUP BY order_date;
    PRINT '    -> gold.dim_date created.';

    --------------------------------------------------------------------------
    -- PART 2: Create the Central Fact Table
    -- This table contains the numeric measures and the keys to link to the
    -- dimensions. We JOIN the silver table with our new dimension tables
    -- to get the correct keys.
    --------------------------------------------------------------------------
    PRINT ' -> Part 2: Creating the Fact table...';

    DROP TABLE IF EXISTS gold.fact_sales_item;
    SELECT
        -- Foreign Keys that link to the Dimension tables
        s.order_date AS date_key,
        s.customer_id AS customer_key,
        s.product_id AS product_key,
        loc.location_key AS location_key,

        -- Degenerate Dimensions (Important attributes that belong here)
        s.order_id,
        s.order_item_id,
        s.delivery_status,

        -- Numeric Measures (The facts)
        s.sales_per_item,
        s.order_item_discount,
        s.order_item_quantity,
        s.dwh_delivery_variance_days
    INTO gold.fact_sales_item
    FROM
        silver.kaggle_supply_chain_cleaned AS s
        -- Join to the location dimension to get the new surrogate key
        JOIN gold.dim_shipping_location AS loc
            ON s.order_city = loc.order_city
            AND s.order_country = loc.order_country
            AND s.order_region = loc.order_region
            AND s.market = loc.market;
    PRINT '    -> gold.fact_sales_item created.';

    --------------------------------------------------------------------------
    -- PART 3: Add Primary and Foreign Key Constraints
    -- This formally defines the relationships and ensures data integrity.
    --------------------------------------------------------------------------
    PRINT ' -> Part 3: Adding Primary and Foreign Keys...';

    -- Add Primary Keys to Dimension tables
    ALTER TABLE gold.dim_customer ADD CONSTRAINT PK_dim_customer PRIMARY KEY (customer_key);
    ALTER TABLE gold.dim_product ADD CONSTRAINT PK_dim_product PRIMARY KEY (product_key);
    ALTER TABLE gold.dim_shipping_location ADD CONSTRAINT PK_dim_shipping_location PRIMARY KEY (location_key);
    ALTER TABLE gold.dim_date ADD CONSTRAINT PK_dim_date PRIMARY KEY (date_key);
    PRINT '    -> Primary Keys added to all dimension tables.';

    -- Add Foreign Keys to the Fact table
    ALTER TABLE gold.fact_sales_item ADD CONSTRAINT FK_fact_customer FOREIGN KEY (customer_key) REFERENCES gold.dim_customer(customer_key);
    ALTER TABLE gold.fact_sales_item ADD CONSTRAINT FK_fact_product FOREIGN KEY (product_key) REFERENCES gold.dim_product(product_key);
    ALTER TABLE gold.fact_sales_item ADD CONSTRAINT FK_fact_shipping_location FOREIGN KEY (location_key) REFERENCES gold.dim_shipping_location(location_key);
    ALTER TABLE gold.fact_sales_item ADD CONSTRAINT FK_fact_date FOREIGN KEY (date_key) REFERENCES gold.dim_date(date_key);
    PRINT '    -> Foreign Keys added to the fact table.';

    PRINT 'Gold Star Schema creation completed successfully!';
END;
GO