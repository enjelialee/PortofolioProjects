SELECT *
FROM covid_deaths_world
;

-- Looking at total cases vs total deaths per country

SELECT location, MAX(total_cases) tots_cases, MAX(total_deaths) tots_deaths, (MAX(total_deaths)/MAX(total_cases))*100 death_percentage
FROM covid_deaths_world
WHERE continent != '' AND total_cases > 0  # some countries don't have any cases or deaths entries thus the specified > 0
GROUP BY location
;


-- Looking at the COVID percentage of total deaths vs total case in the world

SELECT MAX(total_cases) tots_cases, MAX(total_deaths) tots_deaths, (MAX(total_deaths)/MAX(total_cases))*100 death_percentage
FROM covid_deaths_world
WHERE location ='World'
;


-- Looking at total cases vs population
# we're looking at the COVID infection rate in Indonesia from 2020-01-05 to 2024-08-04
SELECT location, `date`, population, total_cases, total_deaths, (total_cases/population)*100 case_percentage
FROM covid_deaths_world
WHERE location = 'Indonesia'
;


-- Looking at countries with highest infection rate compared to population
SELECT location, population, total_cases, (total_cases/population)*100 cases_percentage
FROM covid_deaths_world
#WHERE continent != '' AND total_cases > 0
WHERE `date` = '2024-08-04' AND continent != '' AND total_cases > 0
ORDER BY cases_percentage DESC
;


# we're looking at the COVID infection rate from start to 2024-08 in each country from highest to lowest
# this will be used to estimate the growing rate of COVID infection based on the trend of the data
SELECT location, population, `date`, MAX(total_cases) highest_infection_count, (MAX(total_cases)/population)*100 case_percentage -- (total_deaths/population)*100 death_perc
FROM covid_deaths_world
GROUP BY location, population, `date`
ORDER BY case_percentage desc
;


-- Showing the countries with the highest total death count per population

SELECT location, population, total_deaths, (total_deaths/population)*100 deaths_percentage
FROM covid_deaths_world
WHERE `date` = '2024-08-04' AND continent != '' AND total_cases > 0
ORDER BY deaths_percentage DESC
;


-- Looking at the total death by COVID per continent

SELECT location, total_deaths
FROM covid_deaths_world
WHERE `date` = '2024-08-04' AND continent = '' AND location NOT LIKE '%countries%' AND location NOT LIKE '%Union%' AND location != 'World'
ORDER BY total_deaths DESC
;


-- Looking at the percentage of people vaccinated vs population of each country
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.people_fully_vaccinated, (people_fully_vaccinated/dea.population)*100 vacc
FROM covid_deaths_world dea
JOIN covid_vaccinations_world vac
	ON dea.location = vac.location
    AND dea.`date` = vac.`date`
WHERE dea.continent != ''
;


-- Creating view to store data for later visualization
CREATE VIEW percent_population_vaccinated as
SELECT dea.continent, dea.location, dea.`date`, dea.population, vac.people_fully_vaccinated
FROM covid_deaths_world dea
JOIN covid_vaccinations_world vac
	ON dea.location = vac.location
    AND dea.`date` = vac.`date`
WHERE dea.continent != ''
;

SELECT *
FROM percent_population_vaccinated
;