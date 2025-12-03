/* ---------------------------------------------------------------
   1. LOAD RAW DATA → CREATE STAGING TABLES
---------------------------------------------------------------- */

USE world_layyoffs;

-- Raw Data
SELECT * FROM layoffs_data;

-- Create staging table (same structure as raw)
CREATE TABLE layoff_staging LIKE layoffs_data;

-- Insert all data into staging
INSERT INTO layoff_staging
SELECT *
FROM layoffs_data;


/* ---------------------------------------------------------------
   2. IDENTIFY DUPLICATES USING ROW_NUMBER()
---------------------------------------------------------------- */

WITH duplicates_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
                PARTITION BY Company, Location_HQ, Industry, Laid_Off_Count,
                             Date, Source, Funds_Raised, Stage, Date_Added,
                             Country, Percentage, List_of_Employees_Laid_Off
           ) AS row_num
    FROM layoff_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;


/* ---------------------------------------------------------------
   3. CREATE STAGING2 WITH A ROW_NUM COLUMN FOR CLEANING
---------------------------------------------------------------- */

DROP TABLE IF EXISTS layoff_staging2;

CREATE TABLE layoff_staging2 (
  Company TEXT,
  Location_HQ TEXT,
  Industry TEXT,
  Laid_Off_Count INT,
  Date DATE,
  Source TEXT,
  Funds_Raised DOUBLE,
  Stage TEXT,
  Date_Added DATE,
  Country TEXT,
  Percentage DOUBLE,
  List_of_Employees_Laid_Off TEXT,
  row_num INT
);


-- Insert data + generate row numbers
INSERT INTO layoff_staging2
SELECT Company,
       Location_HQ,
       Industry,
       NULLIF(Laid_Off_Count, ''),                   -- convert '' → NULL
       STR_TO_DATE(Date,'%Y-%m-%d'),                 -- convert to DATE
       Source,
       NULLIF(Funds_Raised, ''),
       Stage,
       STR_TO_DATE(Date_Added,'%Y-%m-%d'),
       Country,
       NULLIF(Percentage,''),
       List_of_Employees_Laid_Off,

       ROW_NUMBER() OVER (
            PARTITION BY Company, Location_HQ, Industry, Laid_Off_Count,
                         Date, Source, Funds_Raised, Stage, Date_Added,
                         Country, Percentage, List_of_Employees_Laid_Off
       ) AS row_num
FROM layoff_staging;


/* ---------------------------------------------------------------
   4. REMOVE DUPLICATES
---------------------------------------------------------------- */

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoff_staging2
WHERE row_num > 1;


/* ---------------------------------------------------------------
   5. STANDARDIZE TEXT COLUMNS
---------------------------------------------------------------- */

-- Trim company names
UPDATE layoff_staging2
SET Company = TRIM(Company);

-- Standardize industry values
UPDATE layoff_staging2
SET Industry = TRIM(Industry);

-- Standardize country format (remove trailing periods)
UPDATE layoff_staging2
SET Country = TRIM(TRAILING '.' FROM Country);


/* ---------------------------------------------------------------
   6. CLEAN NULL / EMPTY VALUES
---------------------------------------------------------------- */

-- Convert empty strings → NULL
UPDATE layoff_staging2
SET Laid_Off_Count = NULL
WHERE Laid_Off_Count = '';

UPDATE layoff_staging2
SET Funds_Raised = NULL
WHERE Funds_Raised = '';

-- Remove rows where Layoff = NULL AND Percentage = NULL → useless rows
DELETE FROM layoff_staging2
WHERE Laid_Off_Count IS NULL
  AND Percentage IS NULL;


/* ---------------------------------------------------------------
   7. DROP HELPER COLUMN
---------------------------------------------------------------- */

ALTER TABLE layoff_staging2
DROP COLUMN row_num;