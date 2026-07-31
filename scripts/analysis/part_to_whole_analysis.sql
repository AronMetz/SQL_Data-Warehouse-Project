
SELECT
category,
category_sales,
SUM(category_sales) OVER() AS total_sales,
CONCAT(CAST((category_sales / SUM(category_sales) OVER()) * 100 AS DECIMAL(10,2)), '%') AS part_to_whole_contribution
FROM (
	SELECT
		dp.category,
		SUM(ft.sales_amount) AS category_sales
	FROM gold.fact_sales ft
	LEFT JOIN gold.dim_products dp
	ON ft.product_key = dp.product_key
	GROUP BY dp.category
)sq
ORDER BY part_to_whole_contribution DESC