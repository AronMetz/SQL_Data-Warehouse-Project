/*
===========================================================================================================
Product Report
===========================================================================================================
Script Purpose:
	This script generates a report on key product metrics and patterns.

Key points:
	1. Provides essential fields such as product name, category, subcategory, and cost.
	2. Aggregates product-level metrics:
		- Total sales
		- Total orders
		- Total quantity sold
		- Total customers (unique)
		- Last order date
		- Lifespan (based on order dates, in months)
	3. Segments products into categories based on revenue (High-Performers, Mid-Range, Low-Performers).
	4. Calculates KPIs:
		- Recency (months since last sale)
		- Average order revenue
		- Average monthly revenue
===========================================================================================================
*/

CREATE VIEW gold.report_products AS

/*
--------------------------------------------------------------
1. Base Table: Retrieving useful columns from database tables
--------------------------------------------------------------
*/

WITH base_table AS (
SELECT
	fs.order_number,
	fs.customer_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dp.product_key,
	dp.product_name,
	dp.category,
	dp.subcategory,
	dp.cost
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL),


/*
--------------------------------------------------------------
2. Product Aggregation: Aggregating key order information at the product level
--------------------------------------------------------------
*/

product_aggregation AS (
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_table
GROUP BY
	product_key,
	product_name,
	category,
	subcategory,
	cost)

	
/*
--------------------------------------------------------------
3. Final Table: Adding the revenue segmentation and product KPIs with other key product information
--------------------------------------------------------------
*/
	
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	CASE WHEN total_sales < 100000 THEN 'Low-Performer'
		 WHEN total_sales BETWEEN 100000 AND 500000 THEN 'Mid-Range'
		 ELSE 'High-Performer'
	END product_segment,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency_months,
	total_sales,
	total_orders,
	total_quantity,
	total_customers,
	lifespan,
	-- Average order revenue
	CASE WHEN total_orders = 0 THEN 0
		 ELSE CAST(total_sales / total_orders AS DECIMAL(10,2))
	END AS avg_order_revenue,

	-- Average monthly revenue
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE CAST(total_sales / lifespan AS DECIMAL (10,2))
	END AS avg_monthly_revenue
FROM product_aggregation
