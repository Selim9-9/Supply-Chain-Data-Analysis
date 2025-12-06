--check Dplicates on order_item_id column
SELECT [order_item_id]
		, COUNT(*)

FROM (SELECT  [order_item_id]
      ,[order_id]
      ,[sales_per_item]
      ,[item_profit]
      ,[item_profit_ratio]
      ,[sales_per_customer]
      ,[order_item_discount]
      ,[order_item_discount_rate]
      ,[order_item_quantity]
      ,[product_price]
      ,[shipping_date]
      ,[actual_shipping_days]
      ,[scheduled_shipping_days]
      ,[delivery_status]
      ,[late_delivery_risk]
      ,[shipping_mode]
      ,[order_date]
      ,[order_status]
      ,[payment_type]
      ,[customer_id]
      ,[customer_segment]
      ,[product_card_id]
      ,[product_name]
      ,[product_category_name]
      ,[product_department_name]
      ,[product_category_id]
      ,[department_id]
      ,[order_city]
      ,[order_state]
      ,[order_country]
      ,[order_region]
      ,[market]
      ,[customer_city]
      ,[customer_state]
      ,[latitude]
      ,[longitude]
      ,[dwh_delivery_variance_days]
      ,[dwh_create_date]
  FROM [supply_chain_data_warehouse].[silver].[kaggle_supply_chain_cleaned]

  )t
  GROUP BY [order_item_id]
  HAVING COUNT(*) >1







-------------------------------------------
--check Duplicates on each row
SELECT 
    order_item_id,
    order_id,
    sales_per_item,
    item_profit,
    item_profit_ratio,
    sales_per_customer,
    order_item_discount,
    order_item_discount_rate,
    order_item_quantity,
    product_price,
    shipping_date,
    actual_shipping_days,
    scheduled_shipping_days,
    delivery_status,
    late_delivery_risk,
    shipping_mode,
    order_date,
    order_status,
    payment_type,
    customer_id,
    customer_segment,
    product_card_id,
    product_name,
    product_category_name,
    product_department_name,
    product_category_id,
    department_id,
    order_city,
    order_state,
    order_country,
    order_region,
    market,
    customer_city,
    customer_state,
    latitude,
    longitude,
    dwh_delivery_variance_days,
    dwh_create_date,
    COUNT(*) AS duplicate_count
FROM silver.kaggle_supply_chain_cleaned
GROUP BY 
    order_item_id,
    order_id,
    sales_per_item,
    item_profit,
    item_profit_ratio,
    sales_per_customer,
    order_item_discount,
    order_item_discount_rate,
    order_item_quantity,
    product_price,
    shipping_date,
    actual_shipping_days,
    scheduled_shipping_days,
    delivery_status,
    late_delivery_risk,
    shipping_mode,
    order_date,
    order_status,
    payment_type,
    customer_id,
    customer_segment,
    product_card_id,
    product_name,
    product_category_name,
    product_department_name,
    product_category_id,
    department_id,
    order_city,
    order_state,
    order_country,
    order_region,
    market,
    customer_city,
    customer_state,
    latitude,
    longitude,
    dwh_delivery_variance_days,
    dwh_create_date
HAVING COUNT(*) > 1;

---------------------------------------------------------------
--check the tables 
SELECT * FROM gold.fact_supply_chain
SELECT * FROM gold.dim_geography
SELECT * FROM gold.dim_date
SELECT * FROM gold.dim_product
SELECT * FROM gold.dim_customer


------------------------------
--check counts of unique values of geo_key column
SELECT  geo_key,
COUNT(*)
FROM gold.fact_supply_chain
GROUP BY geo_key
HAVING geo_key IS NULL
-----------
--check NUlls on the silver layer geo columns
SELECT  
        order_country, order_region, order_state, order_city, market, latitude, longitude
FROM silver.kaggle_supply_chain_cleaned
WHERE latitude IS NULL OR
	  longitude IS NULL OR
	  order_country IS NULL OR
	  order_region IS NULL OR
	  order_city IS NULL OR
	  market IS NULL


	-------------------
-- check not NULL values on the new gold fact table to discvor why the NULLs are presisting
SELECT  g.market,
	   f.order_item_id,
	   f.geo_key,
	   g.order_country,
	   g.order_region, 
	   g.order_state, 
	   g.order_city 
	   

	   
FROM gold.fact_supply_chain  f
LEFT JOIN gold.dim_geography g
ON f.geo_key = g.geo_key
------------------------------------
--everything is ok but let's do sanitychecks:
-- Silver Total Sales
SELECT SUM(sales_per_item) FROM silver.kaggle_supply_chain_cleaned;

-- Gold Total Sales (Should match exactly)
SELECT SUM(sales_per_item) FROM gold.fact_supply_chain;

--keys coverage
SELECT 
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS NoCustomer,
    SUM(CASE WHEN product_key  IS NULL THEN 1 ELSE 0 END) AS NoProduct,
    SUM(CASE WHEN geo_key     IS NULL THEN 1 ELSE 0 END) AS NoGeo,
    SUM(CASE WHEN order_date_key IS NULL THEN 1 ELSE 0 END) AS NoOrderDate,
    SUM(CASE WHEN shipping_date_key IS NULL THEN 1 ELSE 0 END) AS NoShipDate
FROM gold.fact_supply_chain;

