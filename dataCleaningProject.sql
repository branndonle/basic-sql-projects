-- Data Cleaning

SELECT * 
FROM world_layoffs.layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove any columns

CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;

INSERT world_layoffs.layoffs_staging
SELECT * 
FROM world_layoffs.layoffs;


-- 1. Remove Duplicates

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_CTE AS (
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_CTE
WHERE row_num > 1
;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO world_layoffs.layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

DELETE 
FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;

-- ----------------------------------------------------------------------------------------------------------

-- 2. Standardizing the data
SELECT company, TRIM(company)
FROM world_layoffs.layoffs_staging2;

-- Set these to blank spaces to null because it's easier to work with
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = ""; 

-- Categorizing Cryptocurrency and Crypto currency => Crypto

UPDATE world_layoffs.layoffs_staging2 
SET industry = "Crypto" 
WHERE industry LIKE "Crypto%";

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;
-- ----------------------------------------------------------------------------------------------------------
-- Fixing 'United States.'
SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- ----------------------------------------------------------------------------------------------------------

-- Fixing The Date Format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- We're changing the data type of a column DO NOT EVER DO THIS IN A RAW TABLE ONLY ON A STAGING TABLE
ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM world_layoffs.layoffs_staging2;
-- ----------------------------------------------------------------------------------------------------------

-- 3. Null Values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL
;

SELECT  *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL OR industry = "";

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company = "airbnb";

SELECT *
FROM world_layoffs.layoffs_staging2 st1
JOIN world_layoffs.layoffs_staging2 st2
	ON st1.company = st2.company 
    AND st1.location = st2.location
WHERE (st1.industry IS NULL OR st1.industry = '') AND st2.industry is NOT NULL
;


UPDATE world_layoffs.layoffs_staging2 st1
JOIN world_layoffs.layoffs_staging2 st2
	ON st1.company = st2.company 
SET st1.industry = st2.industry
WHERE (st1.industry IS NULL) AND st2.industry is NOT NULL;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'bally%';


-- 4. remove any columns and rows we need to
-- Shows the rows and all columns of the total laid off is null and percentage laid off is null
SELECT * 
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- DELETES THE ROWS WHERE TOTAL LAID OFF AND PERCENTAGE LAID OFF ARE BOTH NULL
DELETE
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM world_layoffs.layoffs_staging2;

-- Deletes the column 'row_num'
ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;
