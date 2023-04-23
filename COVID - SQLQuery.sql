Select *
From PortfolioProject..CovidDeaths
ORDER BY 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--


SELECT location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location LIKE '%states%'
ORDER BY 1,2

SELECT location, population, MAX(Total_Cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentOfPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentOfPopulationInfected desc

SELECT location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is NULL
Group BY location
ORDER BY TotalDeathCount Desc

SELECT *
From PortfolioProject..CovidDeaths
WHERE continent is not NULL
order by 3,4



SELECT continent, MAX(cast(Total_Deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not NULL
Group BY continent
ORDER BY TotalDeathCount Desc

=====
 min 41:40
 =====


 SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
 FROM PortfolioProject..CovidDeaths
 --WHERE location like '%states%'
	WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as TotalCsaes, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null

ORDER BY 1,2


WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3 
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

DROP table if exists #PercentPopulationVaccinated
Create TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255), 
location nvarchar(255),
date datetime, 
population numeric, 
New_Vaccinations numeric, 
RollingPeopleVaccinated numeric, 
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3 


SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3 


-- Drop the existing view

DROP VIEW PercentPopulationVaccinated;

-- Create the new view
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
    --, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null;

SELECT *
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

SELECT TABLE_CATALOG, TABLE_SCHEMA
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

SELECT TABLE_CATALOG, TABLE_SCHEMA
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'PercentPopulationVaccinated';

USE master;

DROP VIEW dbo.PercentPopulationVaccinated;

USE PortfolioProject;

CREATE VIEW dbo.PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
    , SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location ORDER by dea.location, dea.date) as RollingPeopleVaccinated
    --, (RollingPeopleVaccinated/population)*100 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null;

select *
from PercentPopulationVaccinated