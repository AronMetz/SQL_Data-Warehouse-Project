/*
===========================================================================
DDL Script: Create Silver Tables
===========================================================================
Script Purpose:
    This script will make the tables needed for the 'silver' schema,
    dropping any existing tables with the same names.
    Run this script to re-define the DDL structure of the silver layer.
===========================================================================
*/

DROP TABLE IF EXISTS silver.crm_cust_info;
GO
CREATE TABLE silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR (30),
	cst_gndr NVARCHAR (30),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

DROP TABLE IF EXISTS silver.crm_prd_info;
GO
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost DECIMAL(10, 2),
	prd_line NVARCHAR(30),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

DROP TABLE IF EXISTS silver.crm_sales_details;
GO
CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales DECIMAL(10, 2),
	sls_quantity INT,
	sls_price DECIMAL(10, 2),
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

DROP TABLE IF EXISTS silver.erp_cust_az12;
GO
CREATE TABLE silver.erp_cust_az12 (
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(30),
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

DROP TABLE IF EXISTS silver.erp_loc_a101;
GO
CREATE TABLE silver.erp_loc_a101 (
	cid NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
GO
CREATE TABLE silver.erp_px_cat_g1v2 (
	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(30),
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);
GO
