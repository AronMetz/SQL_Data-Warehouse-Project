/*
==============================
Create Database and Schemas
==============================

This script creates the database 'DataWarehouse' after checking whether a database with that name already exists.
If it checks and finds a database with that name, it drops it and then recreates the database.
After doing so, it creates 3 schemas ('bronze', 'silver', 'gold) in the database.

WARNING:
The script will drop any database with the name 'DataWarehouse', so ensure that there isn't anything needed from it, or that you have a backup on standby.
*/


USE master;
GO

-- Drop and recreate database 'DataWarehouse' if it already exists
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
