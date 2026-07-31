/*
===========================================================================================================
Customer Report
===========================================================================================================
Script Purpose:
	This script generates a report on key customer metrics and patterns.

Key points:
	1. Provides essential fields such as names, ages, and transaction details.
	2. Aggregates customer-level metrics:
		- Total sales
		- Total orders
		- Total quantity purchased
		- Total products
		- Last order date
		- Lifespan (based on order dates, in months)
	3. Segments customers into categories based on spending patterns (VIP, Regular, New), and by age group.
	4. Calculates KPIs:
		- Customer activity (months since last order)
		- Average order value
		- Average monthly spending
===========================================================================================================
*/

CREATE VIEW gold.report_customers AS

/*
--------------------------------------------------------------
1. Base Table: Retrieving useful columns from database tables
--------------------------------------------------------------
*/

WITH base_table AS (
SELECT
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dc.customer_key,
	dc.customer_number,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	DATEDIFF(year, dc.birthdate, GETDATE()) AS age
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
WHERE order_date IS NOT NULL),


/*
--------------------------------------------------------------
2. Customer Aggregation: Aggregating key order information at the customer level
--------------------------------------------------------------
*/

customer_aggregation AS (
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	SUM(sales_amount) AS total_spending,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_table
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age)


/*
--------------------------------------------------------------
3. Final Table: Adding the age and customer segmentation, and customer KPIs with other key product information
--------------------------------------------------------------
*/
	
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age BETWEEN 40 AND 49 THEN '40-49'
		 WHEN age BETWEEN 50 AND 59 THEN '50-59'
		 ELSE '60 and above'
	END age_group,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 WHEN lifespan < 12 THEN 'New'
		 ELSE 'N/A'
	END customer_segment,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS customer_activity,
	total_spending,
	total_orders,
	total_quantity,
	total_products,
	lifespan,
	-- Average order value:
	CASE WHEN total_orders = 0 THEN 0
		 ELSE CAST(total_spending / total_orders AS DECIMAL(10,2))
	END AS avg_order_value,
	
	-- Average monthly spending
	CASE WHEN lifespan = 0 THEN total_spending
		 ELSE CAST(total_spending / lifespan AS DECIMAL(10,2))
	END AS avg_monthly_spending
FROM customer_aggregation
