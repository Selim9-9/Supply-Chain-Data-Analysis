/*
===============================================================================
Procedure: silver.load_trim_data_1
Purpose:   Truncates the Silver table and performs a full reload from the
           Bronze table. During the load, it renames columns and applies TRIM()
           to all text-based columns to remove whitespace.
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_trim_data_1
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Step 1: Truncating Silver table and loading fresh data from Bronze with TRIM()...';

    -- Clear Silver table before full reload
    TRUNCATE TABLE silver.kaggle_supply_chain_cleaned;

    INSERT INTO silver.kaggle_supply_chain_cleaned (
        -- ------------------------------------------------------------------
        -- CORE IDENTIFIERS (same order as Silver DDL)
        -- ------------------------------------------------------------------
        order_item_id,
        order_id,

        -- ------------------------------------------------------------------
        -- FINANCIAL PERFORMANCE
        -- ------------------------------------------------------------------
        sales_per_item,
        item_profit,
        item_profit_ratio,
        sales_per_customer,
        order_item_discount,
        order_item_discount_rate,
        order_item_quantity,
        product_price,

        -- ------------------------------------------------------------------
        -- LOGISTICS & DELIVERY
        -- ------------------------------------------------------------------
        shipping_date,
        actual_shipping_days,
        scheduled_shipping_days,
        delivery_status,
        late_delivery_risk,
        shipping_mode,

        -- ------------------------------------------------------------------
        -- ORDER & CUSTOMER
        -- ------------------------------------------------------------------
        order_date,
        order_status,
        payment_type,
        customer_id,
        customer_segment,

        -- ------------------------------------------------------------------
        -- PRODUCT
        -- ------------------------------------------------------------------
        product_card_id,
        product_name,
        product_category_name,
        product_department_name,
        product_category_id,
        department_id,

        -- ------------------------------------------------------------------
        -- GEOGRAPHIC
        -- ------------------------------------------------------------------
        order_city,
        order_state,
        order_country,
        order_region,
        market,
        customer_city,
        customer_state,
        --customer_country,
        latitude,
        longitude,

        -- ------------------------------------------------------------------
        -- DERIVED (only variance here; create_date uses DEFAULT)
        -- ------------------------------------------------------------------
        dwh_delivery_variance_days
    )
    SELECT
        -- CORE IDENTIFIERS (text → TRIM)
        TRIM([order_item_id])      AS order_item_id,
        TRIM([order_id])           AS order_id,

        -- FINANCIAL PERFORMANCE (numeric: no TRIM)
        [order_item_total]         AS sales_per_item,
        [order_profit_per_order]   AS item_profit,
        [order_item_profit_ratio]  AS item_profit_ratio,
        [sales_per_customer]       AS sales_per_customer,
        [order_item_discount]      AS order_item_discount,
        [order_item_discount_rate] AS order_item_discount_rate,
        [order_item_quantity]      AS order_item_quantity,
        [product_price]            AS product_price,

        -- LOGISTICS & DELIVERY
        [shipping_date]            AS shipping_date,
        [days_for_shipping_real]   AS actual_shipping_days,
        [days_for_shipment_scheduled] AS scheduled_shipping_days,
        TRIM([delivery_status])    AS delivery_status,
        [late_delivery_risk]       AS late_delivery_risk,
        TRIM([shipping_mode])      AS shipping_mode,

        -- ORDER & CUSTOMER
        [order_date]               AS order_date,
        TRIM([order_status])       AS order_status,
        TRIM([type])               AS payment_type,
        TRIM([order_customer_id])  AS customer_id,        -- chosen over customer_id
        TRIM([customer_segment])   AS customer_segment,

        -- PRODUCT
        TRIM([order_item_cardprod_id])  AS product_card_id,
        TRIM([product_name])            AS product_name,
        TRIM([category_name])           AS product_category_name,
        TRIM([department_name])         AS product_department_name,
        TRIM([product_category_id])     AS product_category_id,
        TRIM([department_id])           AS department_id,

        -- GEOGRAPHIC
        TRIM([order_city])         AS order_city,
        TRIM([order_state])        AS order_state,
        TRIM([order_country])      AS order_country,
        TRIM([order_region])       AS order_region,
        TRIM([market])             AS market,
        TRIM([customer_city])      AS customer_city,
        TRIM([customer_state])     AS customer_state,
        --TRIM([customer_country])   AS customer_country,
        [latitude]                 AS latitude,
        [longitude]                AS longitude,

        -- DERIVED: keep NULL for now, will be filled in later step
        NULL                       AS dwh_delivery_variance_days
    FROM
        bronze.kaggle_supply_chain_raw;

    PRINT 'Step 1: Load and Trim completed successfully.';
END;
GO