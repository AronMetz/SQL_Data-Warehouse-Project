/*
==================================================================================
Stored Procedure: Full Load Bronze Layer
==================================================================================
Script Purpose:
    Loads data from source systems (external CSV files) into the 'bronze' layer.

Process:
    - Truncates all bronze tables before loading data
    - Uses 'BULK INSERT' to full load the data from the CSV files to the 'bronze' tables

Parameters:
    None.
    No parameters are accepted by this stored procedure.

SQL Statement to Use:
    EXEC bronze.load_bronze

Note: 
	Replace 'FilePath' with the file path of the CSV files.
==================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @bronze_start_time DATETIME, @bronze_end_time DATETIME;
	BEGIN TRY
		SET @bronze_start_time = GETDATE();

		PRINT '===============================';
		PRINT 'Loading Bronze Layer';
		PRINT '===============================';

		PRINT '-------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------';

		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '-> Inserting Data Into Table: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'FilePath\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';
		

		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '-> Inserting Data Into Table: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'FilePath\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';


		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '-> Inserting Data Into Table: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'FilePath\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';

		PRINT '-------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------';

		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '-> Inserting Data Into Table: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'FilePath\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';


		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '-> Inserting Data Into Table: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'FilePath\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';


		SET @start_time = GETDATE();
		PRINT '-> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '-> Inserting Data Into Table: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'FilePath\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '-> Time taken = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '-------------------------';


		PRINT '===============================';
		PRINT 'Bronze Layer Summary';
		PRINT '===============================';

		SET @bronze_end_time = GETDATE();
		PRINT '-> Bronze layer time taken = ' + CAST(DATEDIFF(second, @bronze_start_time, @bronze_end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
		PRINT '=======================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=======================';
	END CATCH
END
