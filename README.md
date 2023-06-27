# COVID-19-EXPLORATORY-DATA-ANALYSIS
![new pic](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/ff740207-104e-4704-a8cb-40076d34b99b)

## INTRODUCTION -
This is an Exploratory Data Analysis on the COVID-19 World Dataset. I utilized SQL Server and MS Excel to analyze the COVID-19 Dataset and gain insights into how the virus has affected different nations. This comprehensive analysis involved data cleaning, analyzing, and querying to uncover patterns, trends, and disparities related to the impact of the pandemic globally.

## DATA SOURCE -
I got the Covid-19 Dataset from [Our World in Data](https://ourworldindata.org/covid-deaths) Website which is based on the complete WHO report on COVID cases and deaths. 

## TOOLS USED -
* MS EXCEL
* SQL SERVER

## DATA CLEANING & FORMATTING USING MS EXCEL -
The numerous steps involved in cleaning and formatting the dataset using MS EXCEL are as follows -

1) Filter out the data from 2020 to 2022 and deleted all the extra rows.
2) Divided the entire dataset into 2 tables - CovidDeaths and CovidVaccinations.
3) In the CovidDeaths table included all the relevant values related to deaths and cases while the CovidVaccinations table included all the relevant values related to tests and vaccinations.
4) Removed all the irrelevant and unnecessary columns such as stringency index, median age, gdp per capita, and many more.
5) Imported both tables into SQL server.


## DATA ANALYSIS & QUERYING USING SQL SERVER -
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types


### QUERIES FOR COVID DEATHS TABLE -


#### Data we are going to use for CovidDeaths -

Select location, date, population , total_cases, new_cases, total_deaths
from Covid.dbo.CovidDeaths
where continent is not null
order by 1,2

 #### Total cases vs New Cases (Death percentage)
 #### Shows likelihood of dying if you catch Covid in India
 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases )*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where continent is not null and location like '%India%' 
order by 1,2

#### Total cases vs Population
#### Shows what Percentage of population gets covid
Select location, date, population,total_cases, (total_cases/population )*100 as PercentPopulationInfected
from Covid.dbo.CovidDeaths  
where continent is not null
order by 1,2

#### Looking at Countries with Highest Infection Rate vs population
Select location, population, Max(total_cases) HighestInfectionCount , MAX((total_cases/population ))*100 as PercentPopulationInfected
from Covid.dbo.CovidDeaths 
where continent is not null
 group by location, population
order by PercentPopulationInfected desc

#### Showing Countries with highest Death Count per population
Select location, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by location
order by TotalDeathCount desc

#### Highest Death Count according to Continents
Select continent, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by continent
order by TotalDeathCount desc

 #### Global Numbers
Select Sum(new_cases) as Total_cases, Sum(new_deaths) as Total_deaths, Sum(new_Deaths) / SUM(new_cases)*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where new_cases <>0 and new_deaths <>0 
and continent is not null 
--group by date
order by 1,2




 ### QUERIES FOR COVID VACCINATIONS TABLE -


#### Looking at Total Population  vs Vaccinations
#### Shows Percentage of Population that has recieved at least one Covid Vaccine

Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null 
order by 2,3


 #### Using CTE to perform Calculation of Total Population  vs Vaccinations

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


 #### Using Temp Table to perform Calculation of Total Population  vs Vaccinations

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


#### Creating View to store data for later visualizations

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





