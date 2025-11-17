/*
the purpose of the script is to create the table of metadata and insert its content
Table name:  metadata.kaggle_field_definitions
*/

-- Drop the metadata table if it already exists from previous runs
IF OBJECT_ID('metadata.kaggle_field_definitions','U') is not null
	Drop TAble metadata.kaggle_field_definitions
GO

-- Create the table to store the field definitions
CREATE Table metadata.kaggle_field_definitions(
	field_name NVARCHAR(100) NOT NULL primary key,
	description NVARCHAR(max) NOT NULL
)



-- Insert Data into the table by bulk insert 
Bulk insert metadata.kaggle_field_definitions
FROM 'F:\Selim\DEPI\DEPI project\Project Folder\DataCo Supply Chanin Dataset\DescriptionDataCoSupplyChain.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
)

