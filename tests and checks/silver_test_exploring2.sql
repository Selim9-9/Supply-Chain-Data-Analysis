--- Discover identifiers and cols probplems
SELECT top 1000

order_item_id,
COUNT(order_id) count_orders
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
GROUP BY order_item_id
HAVING COUNT(order_id) > 1

-- Check Duplicates for order_item_id
SELECT COUNT(*) as number_of_Rows,
order_item_id
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
GROUP BY order_item_id
HAVING COUNT(order_id) > 1


-- Check Duplicates for product_name
SELECT COUNT(*) as number_of_Rows,
product_name,
MIN(product_price) min_product_price,
SUM([order_item_total]) total_sales_per_order
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY number_of_Rows DESC



--check profit columns
SELECT top 1000
order_id,
[benefit_per_order],
[order_profit_per_order],
order_item_total,
[order_item_profit_ratio]
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
--WHERE [order_profit_per_order]<> [benefit_per_order]
ORDER BY order_id DESC


--check category cols:
SELECT distinct category_name
--,category_id,
--product_category_id
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
ORDER BY order_id DESC


--check order_date validtiy
SELECT order_id
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
WHERE  shipping_date < order_date 