/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime
	BEGIN TRY
		
		SET @batch_start_time = GETDATE();
		PRINT '=========================================';
		PRINT 'Loading The Bronze layer';
		PRINT '=========================================';

		PRINT '-----------------------------------------';
		PRINT 'Loading Kaggle Tables';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.kaggle_supply_chain_raw';
		Truncate table bronze.kaggle_supply_chain_raw;

		PRINT'>> Inserting Table: bronze.kaggle_supply_chain_raw';
		BULK INSERT bronze.kaggle_supply_chain_raw
		FROM 'F:\Selim\DEPI\DEPI project\Project Folder\DataCo Supply Chanin Dataset\DataCoSupplyChainDataset.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		 
		PRINT'---------------------------------------------------------'

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.kaggle_tokenized_access_logs';

		TRUNCATE TABLE bronze.kaggle_tokenized_access_logs;

		PRINT'>> Inserting Table: bronze.kaggle_tokenized_access_logs';
		BULK INSERT bronze.kaggle_tokenized_access_logs
		FROM 'F:\Selim\DEPI\DEPI project\Project Folder\DataCo Supply Chanin Dataset\tokenized_access_logs.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds.';
		PRINT'-----------------------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT'==============================================';
		PRINT'Bronze layer is completed';
		PRINT'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds.'
		PRINT'==============================================';
	END TRY
	BEGIN CATCH
	PRINT'=================================================';
	PRINT'ERROR OCCURED DURING LOADING BRONZE TABLE';
	PRINT'ERROR MESSAGE'+ ERROR_MESSAGE();
	PRINT'ERROR NUMBER'+ CAST(ERROR_NUMBER() AS NVARCHAR );
	PRINT'ERROR STATE'+ CAST( ERROR_STATE() AS NVARCHAR);
	PRINT'=================================================';
	END CATCH

END