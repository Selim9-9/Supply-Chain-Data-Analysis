/*
Purpose: This script creates a dedicated database for the Supply Chain Data Analysis Project.
Brief: It sets up the 'supply_chain_data_warehouse' database as the foundation for a layered data warehouse architecture.
       If the database does not exist, it creates the database and initializes the Bronze (raw data ingestion), Silver (cleansed data), 
       ,Gold (business-ready analytics) schemas and metadata schema. 
	   If the database already exists, the script skips creation to avoid errors and ensures idempotency (safe to run multiple times). 
	   This enables ETL pipelines for processing Kaggle-sourced supply chain data 
       (e.g., orders, customers, products) into structured layers for analysis, reporting, and visualization in tools like Tableau or Python.
*/

USE master;
GO

-- Check if the database already exists; if it does, skip creation
IF DB_ID('supply_chain_data_warehouse') IS NULL
BEGIN
	PRINT 'Creating Database named: supply_chain_data_warehouse';
	CREATE DataBase supply_chain_data_warehouse;
END
ELSE
BEGIN
	PRINT 'Database supply_chain_data_warehouse already exists. Skipping creation';
END
GO


-- Switch to the database (safe even if it existed)
USE supply_chain_data_warehouse;
GO

-- Create schemas only if they don't exist (idempotent)


CREATE SCHEMA bronze;

GO
--

CREATE SCHEMA silver;

GO
--


CREATE SCHEMA gold;

GO

-- Create metadata schema if not existing
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name  = 'metadata')
	EXEC ('CREATE SCHEMA metadata');
GO
