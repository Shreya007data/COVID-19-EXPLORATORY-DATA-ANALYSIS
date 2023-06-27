--COVID DEATHS

Select*from Covid.dbo.CovidDeaths 
where continent is not null
order by location,date


--Data we are going to use for CovidDeaths
Select location, date, population , total_cases, new_cases, total_deaths
from Covid.dbo.CovidDeaths
where continent is not null
order by 1,2

--Total cases vs New Cases (Death percentage)
--Shows likelihood of dying if you catch Covid in India
Select location, date, total_cases, total_deaths, (total_deaths/total_cases )*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where continent is not null and location like '%India%' 
order by 1,2

--Total cases vs Population
--Shows what Percentage of population gets covid
Select location, date, population,total_cases, (total_cases/population )*100 as PercentPopulationInfected
from Covid.dbo.CovidDeaths  
where continent is not null
order by 1,2

--Looking at Countries with Highest Infection Rate vs population
Select location, population, Max(total_cases) HighestInfectionCount , MAX((total_cases/population ))*100 as PercentPopulationInfected
from Covid.dbo.CovidDeaths 
where continent is not null
 group by location, population
order by PercentPopulationInfected desc

--Showing Countries with highest Death Count per population
Select location, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by location
order by TotalDeathCount desc

-- Highest Death Count according to Continents
Select continent, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by continent
order by TotalDeathCount desc

--Global Numbers
Select Sum(new_cases) as Total_cases, Sum(new_deaths) as Total_deaths, Sum(new_Deaths) / SUM(new_cases)*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where new_cases <>0 and new_deaths <>0 
and continent is not null 
--group by date
order by 1,2


--COVID VACCINATIONS


--Looking at Total Population  vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null 
order by 2,3


--Using CTE to perform Calculation of Total Population  vs Vaccinations

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null 
--order by 2,3
)

select *,(RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage From popvsvac --where location like '%India%'


--Using Temp Table to perform Calculation of Total Population  vs Vaccinations

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(continent nvarchar(50), 
location nvarchar(50), 
date datetime, 
population float, 
new_vaccinations float, 
RollingPeopleVaccinated float) 

Insert into #PercentPopulationVaccinated
Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null 
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercentage From  #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationvaccinated as
Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null


CREATE VIEW TotalDeathCount as
Select continent, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by continent
--order by TotalDeathCount desc


CREATE VIEW GlobalNumbers as
Select Sum(new_cases) as Total_cases, Sum(new_deaths) as Total_deaths, Sum(new_Deaths) / SUM(new_cases)*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where new_cases <>0 and new_deaths <>0 
and continent is not null 
group by date
--order by 1,2