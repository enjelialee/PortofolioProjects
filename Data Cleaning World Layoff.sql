-- Data Cleaning Project

SELECT *
FROM layoffs;

-- 1. Remove duplicates (if there were any)
-- 2. Standarize the data 
-- 3. Null values or blank values
-- 4. Remove any columns

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging
;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Remove Duplicates 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte as
(
SELECT *
FROM layoffs_staging
UNION
SELECT *
FROM layoffs_staging
)
SELECT *, ROW_NUMBER() OVER(ORDER BY company) num
FROM duplicate_cte;

CREATE TABLE my_layoffs_staging2
LIKE layoffs_staging;

INSERT my_layoffs_staging2
SELECT *
FROM layoffs_staging
UNION
SELECT *
FROM layoffs_staging
ORDER BY company;

SELECT *, ROW_NUMBER() OVER(ORDER BY company) num
FROM my_layoffs_staging2;

# Removing Duplicates with SELECT DISTINCT
CREATE TABLE layoffs_staging2
LIKE layoffs_staging;

INSERT layoffs_staging2
SELECT DISTINCT *
FROM layoffs_staging
ORDER BY company;

SELECT DISTINCT *
FROM layoffs_staging2;


-- Stadarizing Data

SELECT DISTINCT company
FROM my_layoffs_staging2;

SELECT DISTINCT company, TRIM(company)
FROM my_layoffs_staging2;

UPDATE my_layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM my_layoffs_staging2;

SELECT *
FROM my_layoffs_staging2
WHERE industry LIKE "Crypto%";

UPDATE my_layoffs_staging2
SET industry = "Crypto" 
WHERE industry LIKE "Crypto%";

SELECT DISTINCT country, TRIM(TRAILING "." FROM country)
FROM my_layoffs_staging2
ORDER BY 1;

SELECT *
FROM my_layoffs_staging2
WHERE country LIKE "United States_";

UPDATE my_layoffs_staging2
SET country = TRIM(TRAILING "." FROM country);

SELECT `date`,
STR_TO_DATE(`date`, "%m/%d/%Y")   # capital Y works for the 4 digit year
FROM my_layoffs_staging2
;

UPDATE my_layoffs_staging2
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

ALTER TABLE my_layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM my_layoffs_staging2;


-- Nulls and Blank Values

SELECT *
FROM my_layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM my_layoffs_staging2
WHERE company = "Airbnb";

SELECT *
FROM my_layoffs_staging2
WHERE industry IS NULL
OR industry = "";


SELECT *
FROM my_layoffs_staging2 t1
JOIN my_layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry != "";

SELECT *
FROM my_layoffs_staging2 t1
JOIN my_layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry IS NOT NULL;

UPDATE my_layoffs_staging2 t1
JOIN my_layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = "")
AND (t2.industry IS NOT NULL AND t2.industry != "");


-- Remove any columns

SELECT *
FROM my_layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE   # removes rows
FROM my_layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE practices.writer_bio_what   	# removes columns
DROP COLUMN Nr;

SELECT *
FROM writer_bio_what;

SELECT *, ROW_NUMBER() OVER(ORDER BY company) num
FROM my_layoffs_staging2;









