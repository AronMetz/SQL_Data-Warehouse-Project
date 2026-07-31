
WITH segment_conditions AS (

SELECT
dc.customer_key,
SUM(fs.sales_amount) AS spending,
MIN(fs.order_date) AS first_order,
MAX(fs.order_date) AS last_order,
DATEDIFF(month, MIN(fs.order_date), MAX(fs.order_date)) AS lifespan
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key),

segments AS (
SELECT
customer_key,
CASE WHEN lifespan >= 12 AND spending > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND spending <= 5000 THEN 'Regular'
	 WHEN lifespan < 12 THEN 'New'
	 ELSE 'N/A'
END customer_segment
FROM segment_conditions)


SELECT
customer_segment,
COUNT(customer_key) AS number_of_customers
FROM segments
GROUP BY customer_segment
ORDER BY number_of_customers DESC