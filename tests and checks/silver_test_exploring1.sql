--identifying Duplicated Columns:
SELECT TOP 1000 order_id, [order_item_cardprod_id],[product_card_id]
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
ORDER BY order_id DESC



SELECT TOP 1000 order_id, [benefit_per_order], [order_profit_per_order]
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
ORDER BY order_id DESC



SELECT TOP 1000 order_id, [order_customer_id],[customer_id]
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
ORDER BY order_id DESC



SELECT TOP 1000 order_id, [order_item_cardprod_id],[order_item_id],[product_card_id]
FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
ORDER BY order_id DESC



SELECT TOP 1000 order_id,
order_item_id,
category_id,
department_id,
product_category_id

FROM [supply_chain_data_warehouse].[bronze].[kaggle_supply_chain_raw]
WHERE order_id !> 9666
ORDER BY order_id DESC



SELECT top 1000 order_id,
order_city,
customer_city,
customer_id,
COUNT (order_id) over(partition by order_id) as num_of_orders
FROM [bronze].[kaggle_supply_chain_raw]
ORDER BY COUNT (order_id) over(partition by order_id) DESC


