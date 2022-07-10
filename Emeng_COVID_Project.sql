-- Double checking whether tables were imported 

SELECT * 
FROM covid.covid_deaths
ORDER BY 3,4;

SELECT * 
FROM covid.covid_vaccinations
ORDER BY 3,4;

-- Selecting data to be used 

SELECT 
	location, 
    date, 
    total_cases,
    new_cases,
    total_deaths,
    population
FROM covid.covid_deaths
ORDER BY 1,2;

-- Looking at COVID fatality rates

SELECT 
	location, 
    date, 
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS COVIDFatalityPercentage
FROM covid.covid_deaths
ORDER BY 1,2;

-- Looking at COVID fatality rate for United States

SELECT 
	location, 
    date, 
    total_cases,
    total_deaths,
    (total_deaths/total_cases)*100 AS COVIDFatalityPercentage
FROM covid.covid_deaths
WHERE location LIKE 'united states'
ORDER BY 1,2;

-- Total Cases VS Population 

SELECT 
	location, 
    date, 
    new_cases,
    total_cases,
    population,
    (total_cases/population)*100 AS PopulationInfectedPercentage
FROM covid.covid_deaths
ORDER BY 1,2;

-- Countries with highest COVID infection rates in their populations

SELECT 
	location, 
    population,
    MAX(total_cases) AS HighestInfectedCases,
    MAX((total_cases/population)*100) AS PopulationInfectedPercentage
FROM covid.covid_deaths
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC;

-- Countries with highest death rates per population

SELECT 
	location, 
    population,
    MAX(total_deaths) AS TotalDeathCount,
    MAX((total_deaths/population)*100) AS DeathPercentageofPopulation
FROM covid.covid_deaths
GROUP BY location, population
ORDER BY DeathPercentageofPopulation DESC;

-- Highest death counts by continent 

SELECT 
	continent,
    MAX(total_deaths) AS TotalDeathCount
FROM covid.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC; 

-- Continents with highest death counts compared to population

SELECT 
	continent,
    MAX(total_deaths) AS TotalDeathCount,
    MAX((total_deaths/population)*100) AS DeathsPopulationPercentage
FROM covid.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathsPopulationPercentage DESC; 

-- Global Fatality Rate  

SELECT 
	date,
    SUM(new_cases),
    SUM(new_deaths),
    (SUM(new_deaths)/SUM(new_cases))*100 AS GlobalFatalityRate
FROM covid.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


-- Total Population VS Vaccinations

SELECT 
	d.continent, 
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, 
		d.date) AS RollingPeopleVaccinated
FROM covid.covid_deaths d
JOIN covid.covid_vaccinations v 
	ON d.location = v.location
WHERE d.continent IS NOT NULL 
ORDER BY 2,3;

-- CTE 

WITH PopvsVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated) 
AS
(SELECT 
	d.continent, 
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, 
		d.date) AS RollingPeopleVaccinated
FROM covid.covid_deaths d
JOIN covid.covid_vaccinations v 
	ON d.location = v.location
WHERE d.continent IS NOT NULL 
)
SELECT * 
FROM PopvsVac;

-- Creating Views for Visualizations 

CREATE VIEW HighestCOVIDInfectionRatesByCountry AS
SELECT 
	location, 
    population,
    MAX(total_cases) AS HighestInfectedCases,
    MAX((total_cases/population)*100) AS PopulationInfectedPercentage
FROM covid.covid_deaths
GROUP BY location, population
ORDER BY PopulationInfectedPercentage DESC;


CREATE VIEW HighestCOVIDDeathRatesByCountry AS 
SELECT 
	location, 
    population,
    MAX(total_deaths) AS TotalDeathCount,
    MAX((total_deaths/population)*100) AS DeathPercentageofPopulation
FROM covid.covid_deaths
GROUP BY location, population
ORDER BY DeathPercentageofPopulation DESC;


CREATE VIEW GlobalFatalityRate AS 
SELECT 
	date,
    SUM(new_cases),
    SUM(new_deaths),
    (SUM(new_deaths)/SUM(new_cases))*100 AS GlobalFatalityRate
FROM covid.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;


CREATE VIEW PercentPopulationVaccinated AS
SELECT 
	d.continent, 
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, 
		d.date) AS RollingPeopleVaccinated
FROM covid.covid_deaths d
JOIN covid.covid_vaccinations v 
	ON d.location = v.location
WHERE d.continent IS NOT NULL; 


