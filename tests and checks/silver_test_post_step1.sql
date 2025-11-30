--EXEC silver.load_trim_data_1

--to print headers only:
SELECT 
    'order_item_id' AS [order_item_id],
    'order_id' AS [order_id],
    'sales_per_item' AS [sales_per_item],
    'item_profit' AS [item_profit],
    'item_profit_ratio' AS [item_profit_ratio],
    'sales_per_customer' AS [sales_per_customer],
    'order_item_discount' AS [order_item_discount],
    'order_item_discount_rate' AS [order_item_discount_rate],
    'order_item_quantity' AS [order_item_quantity],
    'product_price' AS [product_price],
    'shipping_date' AS [shipping_date],
    'actual_shipping_days' AS [actual_shipping_days],
    'scheduled_shipping_days' AS [scheduled_shipping_days],
    'delivery_status' AS [delivery_status],
    'late_delivery_risk' AS [late_delivery_risk],
    'shipping_mode' AS [shipping_mode],
    'order_date' AS [order_date],
    'order_status' AS [order_status],
    'payment_type' AS [payment_type],
    'customer_id' AS [customer_id],
    'customer_segment' AS [customer_segment],
    'product_card_id' AS [product_card_id],
    'product_name' AS [product_name],
    'product_category_name' AS [product_category_name],
    'product_department_name' AS [product_department_name],
    'product_category_id' AS [product_category_id],
    'department_id' AS [department_id],
    'order_city' AS [order_city],
    'order_state' AS [order_state],
    'order_country' AS [order_country],
    'order_region' AS [order_region],
    'market' AS [market],
    'customer_city' AS [customer_city],
    'customer_state' AS [customer_state],
    'customer_country' AS [customer_country],
    'latitude' AS [latitude],
    'longitude' AS [longitude],
    'dwh_delivery_variance_days' AS [dwh_delivery_variance_days],
    'dwh_create_date' AS [dwh_create_date]
WHERE 1 = 0;  -- Ensures no data rows, just the header row


-----------------------------------------
--check profit column outleirs:

SELECT COUNT([order_item_id])

FROM [supply_chain_data_warehouse].[silver].[kaggle_supply_chain_cleaned]

WHERE ABS(item_profit) > (sales_per_item * 2.8);


---
