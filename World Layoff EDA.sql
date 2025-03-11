-- Exploratory Data Analysis

SELECT * 
FROM my_layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM my_layoffs_staging2;

SELECT *
FROM my_layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM my_layoffs_staging2
;

SELECT country, SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY country
ORDER BY 2 desc
;

SELECT *
FROM my_layoffs_staging2;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;

SELECT stage, SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;

SELECT company, AVG(percentage_laid_off)
FROM my_layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

SELECT SUBSTRING(`date`, 1, 7) `MONTH`, SUM(total_laid_off)
FROM my_layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;


WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) `MONTH`, SUM(total_laid_off) total_off
FROM my_layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) rolling_total
FROM Rolling_total;


SELECT company, `date`, MAX(total_laid_off)
FROM my_layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC
;

SELECT company, `date`, SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC
;

SELECT *
FROM my_layoffs_staging2;

WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM my_layoffs_staging2
GROUP BY company, YEAR(`date`)
;

SELECT company, YEAR(`date`), total_laid_off
FROM my_layoffs_staging2
;










