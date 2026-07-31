
WITH yearly_product_sales AS (
SELECT
YEAR(fs.order_date) as order_year,
dp.product_name,
SUM(fs.sales_amount) AS current_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE fs.order_date IS NOT NULL
GROUP BY 
YEAR(fs.order_date),
dp.product_name
),

target_product_sales AS (
SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS average_sales,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales
FROM yearly_product_sales
)

SELECT
order_year,
product_name,
current_sales,
average_sales,
current_sales - average_sales AS diff_average,
CASE WHEN current_sales - average_sales > 0 THEN 'Above Average'
	 WHEN current_sales - average_sales < 0 THEN 'Below Average'
	 ELSE 'Average'
END average_change,
-- YoY analysis
COALESCE(CAST(previous_year_sales AS VARCHAR), 'N/A') AS previous_year_sales,
COALESCE(CAST(current_sales - previous_year_sales AS VARCHAR), 'N/A') AS diff_previous,
CASE WHEN current_sales - previous_year_sales > 0 THEN 'Increase'
	 WHEN current_sales - previous_year_sales < 0 THEN 'Decrease'
	 ELSE 'No Change'
END previous_change
FROM target_product_sales
ORDER BY
product_name