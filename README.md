**Problem Statement**
______________________________________________________________________________________________________
We are analysing Layoffs data to identify which countries, industries and locations had the most number of layoffs after Covid pandemic. The dataset utilized in this project is sourced from the Kaggle Layoffs Dataset.

**Purpose of the Project**
________________________________________________________________________________________________________
The main goal of this project is to gain understanding from Layoffs dataset, exploring the various industries and timelines that influence layoffs across different countries.

**About Data**
________________________________________________________________________________________________________
This project's data was obtained from the Kaggle Layoffs Dataset and it encompasses the layoffs from across the world after Covid-19 pandemic. The data contains 9 columns and 3300 rows:
| Column         | Description                      | Data Type |
| -------------- | -------------------------------- | --------- |
| Company        | Name of the company              | VARCHAR   |
| Location_HQ    | Company headquarters             | VARCHAR   |
| Industry       | Industry sector                  | VARCHAR   |
| Laid_Off_Count | Number of employees laid off     | INT       |
| Percentage     | Percentage of employees laid off | FLOAT     |
| Date           | Layoff date                      | DATE      |
| Stage          | Funding stage                    | VARCHAR   |
| Country        | Country of the company           | VARCHAR   |
| Funds_Raised   | Total funds raised               | FLOAT     |



**Analysis List**
________________________________________________________________________________________________________
Industry Analysis
The objective of this analysis is to find which Industry had the most number of layoffs after the Covid-19 pandemic.

Company Analysis
Perform an analysis on the data to gain insights into different companies, determine the company which laid off most employees.

Country Analysis
The objective of this analysis is to find which Country had the most number of layoffs after the Covid-19 pandemic.

Stage Analysis
Perform an analysis on the data to gain insights into different stages of the company, to determine the company which laid off most employees.


**Approach Used**
______________________________________________________________________________________________________
**🧹 1. Data Cleaning (MySQL)**

**Cleaning steps performed using SQL:**

✔ Created staging tables
✔ Identified duplicate rows using ROW_NUMBER()
✔ Removed duplicates
✔ Converted blank values → NULL
✔ Cleaned dates with STR_TO_DATE()
✔ Trimmed text fields
✔ Removed rows with both Laid_Off_Count & Percentage missing
✔ Standardized countries & industries

Full SQL script includes:

Staging table creation

Duplicate detection

Data standardization

Missing value handling

Stored as:
📄 01_Data_Cleaning.sql
**2. Exploratory Data Analysis (EDA)**

Conducting exploratory data analysis is essential to address the project's listed questions and objectives.

Questions I wanted to answer from this dataset

```Total Number of employees laid off in the past 4 years
Select sum(Laid_Off_Count) as Total_Layoffs
from layoff_staging2```
