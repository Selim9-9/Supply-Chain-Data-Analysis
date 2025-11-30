/*
===============================================================================
Procedure: silver.exclude_invalid_rows_2
Purpose:   Second cleaning action. Deletes rows from the Silver table that
           have logical errors:
             - suspicious fraud status
             - zero / negative values in key numeric columns
             - NULLs in important analysis columns

Usage Example: EXEC silver.exclude_invalid_rows_2
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.exclude_invalid_rows_2
AS
BEGIN
    SET NOCOUNT ON;

    PRINT 'Step 2: Deleting rows with logical errors (fraud, invalid values, critical NULLs)...';

    DELETE FROM silver.kaggle_supply_chain_cleaned
    WHERE
        ----------------------------------------------------------------------
        -- 1) Suspicious fraud orders
        ----------------------------------------------------------------------
        order_status = 'SUSPECTED_FRAUD'

        ----------------------------------------------------------------------
        -- 2) Zero / negative values in inappropriate numeric columns
        ----------------------------------------------------------------------
        OR order_item_quantity <= 0           -- quantity must be > 0
        OR sales_per_item     <= 0           -- total line sales should be > 0
        OR product_price      <= 0           -- product price should be > 0
        OR order_item_discount_rate < 0      -- discount rate between 0 and 1
        OR order_item_discount_rate > 1
        OR actual_shipping_days    < 0       -- cannot ship before order in days
        OR scheduled_shipping_days < 0       -- scheduled days cannot be negative

        ----------------------------------------------------------------------
        -- 3) NULLs in important analysis columns
        --    (adjust this list to match your business rules)
        ----------------------------------------------------------------------
        OR order_id              IS NULL
        OR order_item_id         IS NULL
        OR order_date            IS NULL
        OR sales_per_item        IS NULL
        OR product_price         IS NULL
        OR order_item_quantity   IS NULL
        OR order_country         IS NULL
        OR customer_segment      IS NULL
        OR product_category_name IS NULL;

	PRINT ' -> ' + CAST(@@ROWCOUNT AS VARCHAR) + ' invalid rows were deleted.';
    PRINT 'Step 2: Deletion of invalid rows completed.';
END;
GO