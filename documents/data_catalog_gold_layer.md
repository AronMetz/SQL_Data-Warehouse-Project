# Data Catalog for the Gold Layer

## Intro
The gold layer represents the final tables prepared for business use, from analytics to reporting on data. It consists of **2 dimension** tables and **1 fact** table.
Namely, the **dim_customers** table, the **dim_products** table and the **fact_sales** table.

---

### 1. gold.dim_customers

Stores information about customers, enriched by location and background data.

| Column Name | Data Type | Description |
| --- | --- | --- |
| customer_key | INT | Surrogate key |
| customer_id | INT | Unique numerical identifier assigned to each customer |
| customer_number | NVARCHAR(50) | Alphanumeric identifier assigned to each customer, used for referencing and JOINs |
| first_name | NVARCHAR(50) | First name of customer |
| last_name | NVARCHAR(50) | Last name of customer |
| country | NVARCHAR(50) | Country of customer (e.g. 'Germany') |
| marital_status | NVARCHAR(30) | Marital status of customer (e.g. 'Single', 'Married') |
| gender | NVARCHAR(30) | Gender of customer (e.g. 'Male', 'Female', 'N/A') |
| birthdate | DATE | Birthday of customer (e.g. '2000-12-12') |
| create_date | DATE | Date of customer record being entered into system |

---

### 2. gold.dim_products

Stores information about products, enriched by category information.

| Column Name | Data Type | Description |
| --- | --- | --- |
| product_key | INT | Surrogate key |
| product_id | INT | Unique identifier assigned to each product, used for referencing and JOINs |
| product_number | NVARCHAR(50) | Alphanumeric identifier assigned to each product |
| product_name| NVARCHAR(50) | Name of the product, including details such as type, colour and size |
| category_id | NVARCHAR(50) | Unique identifier assigned to each category of product |
| category | NVARCHAR(50) | Names of each category, referring to each products' general classification |
| subcategory | NVARCHAR(50) | Names of each subcategory, referring to each products' specific classification |
| maintenance_required | NVARCHAR(30) | Indicates whether maintenance is required (e.g. 'Yes', 'No')
| cost | DECIMAL(10, 2) | The cost of each product |
| product_line | NVARCHAR(30) | The product line each product belongs to (e.g. 'Touring', 'Other Sales')
| start_date | DATE | The start date when the product was added to the portfolio, up until current time |

---

### 3. gold.fact_sales

Stores information about transactions, purposed for analytics and reporting.

| Column Name | Data Type | Description |
| --- | --- | --- |
| order_number | NVARCHAR(50) | Unique alphanumeric identifier assigned to each sales order |
| product_key | INT | Surrogate key linking the order to the product dimension table |
| customer_key | INT | Surrogate key linking the order to the customer dimension table |
| order_date | DATE | The date the order was placed |
| shipping_date | DATE | The date the order was shipped |
| due_date | DATE | The date the order payment was due |
| sales_amount | DECIMAL(10, 2) | The total value sold in the order |
| quantity | INT | The quantity of products sold in the order |
| price | DECIMAL(10, 2) | The price per unit of the product in the order |
