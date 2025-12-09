/*
===============================================================================
Procedure: silver.final_clean_and_enrich_3
Purpose: Performs all final cleaning, standardization, and enrichment.
           - Standardizes delivery status and product categories.
           - Translates the most common country names to English.
           - Makes a business assumption to convert 'PAYMENT' to 'Credit Card'.
           - Populates the DWH delivery variance column.
Usage Example: EXEC silver.final_clean_and_enrich_3
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.final_clean_and_enrich_3
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @rows_affected INT;
    PRINT 'Step 3: Applying final standardization and enrichment...';
    --------------------------------------------------------------------------
    -- Action 1: Consolidate all value standardization and translation
    --------------------------------------------------------------------------
    PRINT ' -> Action 3.1: Standardizing categories and translating languages...';
    UPDATE silver.kaggle_supply_chain_cleaned
    SET
		-- Standardize order_status to title case (first capital, rest lower)
        order_status =  CONCAT(UPPER(LEFT(order_status, 1)), LOWER(SUBSTRING(order_status, 2, LEN(order_status))))  -- Title case fallback
                       ,
        -- Standardize for delivery status and product names
        delivery_status = CASE
                              WHEN delivery_status = 'Shipping on time' THEN 'On time'
                              WHEN delivery_status = 'Late delivery' THEN 'Late'
                              ELSE CONCAT(UPPER(LEFT(delivery_status, 1)), LOWER(SUBSTRING(delivery_status, 2, LEN(delivery_status))))  
                          END,
        product_category_name = CASE
                                    WHEN product_category_name = 'Women''s Apparel' THEN 'Women''s Clothing'
                                    ELSE product_category_name
                                END,
        -- Business Assumption: Convert ambiguous 'PAYMENT' to 'Credit Card'
        payment_type = CASE
                           WHEN UPPER(payment_type) = 'PAYMENT' THEN 'Credit Card'
                           ELSE CONCAT(UPPER(LEFT(payment_type, 1)), LOWER(SUBSTRING(payment_type, 2, LEN(payment_type))))
                       END,
        -- Translate the most frequent values in `order_country` as requested
        order_country = CASE
                            WHEN order_country = 'Estados Unidos' THEN 'United States'
                            WHEN order_country = 'México' THEN 'Mexico'
                            WHEN order_country = 'Alemania' THEN 'Germany'
                            WHEN order_country = 'Francia' THEN 'France'
                            WHEN order_country = 'Reino Unido' THEN 'United Kingdom'

                            -- All other countries will remain as they are
                            ELSE order_country
                        END,
        -- Fix for customer_state zips (inconsistent values like 91732/95758 → 'CA')
        customer_state = CASE
                             WHEN customer_state IN ('91732', '95758') THEN 'CA'  -- Map zips to state (based on patterns)
                             WHEN LEN(customer_state) <> 2 THEN NULL
							 ELSE customer_state
                         END,
		-- Standarize late_delivery_risk column:
		late_delivery_risk = CASE WHEN late_delivery_risk = 0 THEN 'Was_on_time' ELSE 'Was_late' END;

    PRINT ' -> ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows updated by standardization rules.';
    --------------------------------------------------------------------------
    -- Action 2: Populate the DWH Derived Column
    --------------------------------------------------------------------------
    PRINT ' -> Action 3.2: Populating DWH derived columns...';
    UPDATE silver.kaggle_supply_chain_cleaned
    SET dwh_delivery_variance_days = actual_shipping_days - scheduled_shipping_days;  -- Simple subtraction for INT days (positive = late)

    PRINT ' -> ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows updated with delivery variance.';
    PRINT 'Step 3: Final cleaning and enrichment completed successfully.';
END;
GO
