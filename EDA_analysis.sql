/* ===============================================================
                     📊 EXPLORATORY DATA ANALYSIS
=============================================================== */

-- Raw check
SELECT * FROM layoff_staging2;


-------------------- BASIC STATS --------------------

-- Total rows
SELECT COUNT(*) AS total_rows
FROM layoff_staging2;

-- Total companies
SELECT COUNT(DISTINCT Company) AS distinct_companies
FROM layoff_staging2;

-- Max layoffs
SELECT MAX(Laid_Off_Count) AS max_laid_off,
       MAX(Percentage) AS max_percentage
FROM layoff_staging2;


-------------------- COMPANY ANALYSIS --------------------

-- Total layoffs per company
SELECT Company, SUM(Laid_Off_Count) AS total_laid_off
FROM layoff_staging2
GROUP BY Company
ORDER BY total_laid_off DESC;

-- Companies that laid off 100% (shutdowns)
SELECT Company, Industry, Location_HQ
FROM layoff_staging2
WHERE Percentage = 1;


-------------------- INDUSTRY ANALYSIS --------------------

SELECT Industry, SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY Industry
ORDER BY total DESC;


-------------------- COUNTRY ANALYSIS --------------------

SELECT Country, SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY Country
ORDER BY total DESC;


-------------------- TIME TREND ANALYSIS --------------------

-- Date range
SELECT MIN(Date) AS earliest, MAX(Date) AS latest
FROM layoff_staging2;

-- Yearly layoffs
SELECT YEAR(Date) AS year, SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY YEAR(Date)
ORDER BY year DESC;

-- Monthly trend
SELECT DATE_FORMAT(Date, '%Y-%m') AS month,
       SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY month
ORDER BY month ASC;


-------------------- STAGE ANALYSIS --------------------

SELECT Stage, SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY Stage
ORDER BY total DESC;


-------------------- LOCATION ANALYSIS --------------------

SELECT Location_HQ, SUM(Laid_Off_Count) AS total
FROM layoff_staging2
GROUP BY Location_HQ
ORDER BY total DESC;


-------------------- FINANCIAL ANALYSIS --------------------

-- Companies with $1B+ funding
SELECT COUNT(*)
FROM layoff_staging2
WHERE Funds_Raised > 1000000000;


-------------------- TOP 5 COMPANIES PER YEAR --------------------

WITH CompanyYear AS (
    SELECT Company,
           YEAR(Date) AS year,
           SUM(Laid_Off_Count) AS total_laid_off
    FROM layoff_staging2
    GROUP BY Company, YEAR(Date)
),
Ranked AS (
    SELECT *,
           DENSE_RANK() OVER (
                PARTITION BY year ORDER BY total_laid_off DESC
           ) AS ranking
    FROM CompanyYear
)
SELECT *
FROM Ranked
WHERE ranking <= 5
ORDER BY year DESC, ranking ASC;
