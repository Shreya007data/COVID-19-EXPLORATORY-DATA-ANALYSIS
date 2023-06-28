# COVID-19-EXPLORATORY-DATA-ANALYSIS
![new pic](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/ff740207-104e-4704-a8cb-40076d34b99b)

## INTRODUCTION 
This is an Exploratory Data Analysis on the COVID-19 World Dataset. I utilized SQL Server and MS Excel to analyze the COVID-19 Dataset and gain insights into how the virus has affected different nations. This comprehensive analysis involved data cleaning, analyzing, and querying to uncover patterns, trends, and disparities related to the impact of the pandemic globally.

## DATA SOURCE 
I got the Covid-19 Dataset from [Our World in Data](https://ourworldindata.org/covid-deaths) Website which is based on the complete WHO report on COVID cases and deaths. 

## TOOLS USED 
* MS EXCEL
* SQL SERVER

## DATA CLEANING & FORMATTING USING MS EXCEL 
The numerous steps involved in cleaning and formatting the dataset using MS EXCEL are as follows -

1) Filter out the data from 2020 to 2022 and deleted all the extra rows.
2) Divided the entire dataset into 2 tables - CovidDeaths and CovidVaccinations.
3) In the CovidDeaths table included all the relevant values related to deaths and cases while the CovidVaccinations table included all the relevant values related to tests and vaccinations.
4) Removed all the irrelevant and unnecessary columns such as stringency index, median age, gdp per capita, and many more.
5) Imported both tables into SQL server.


## DATA ANALYSIS & QUERYING USING SQL SERVER 


 #### Death percentage of people dying from covid in India

```SQL
Select location, date, total_cases, total_deaths, (total_deaths/total_cases )*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where continent is not null and location like '%India%' 
order by 1,2
```
 ![sql 1](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/f64ca3f5-7496-44d2-a6e0-6bcc5f82fe74)



#### Highest Death Count according to Continents

```SQL
Select continent, Max(total_deaths) as TotalDeathCount
from Covid.dbo.CovidDeaths 
where continent is not null
 group by continent
order by TotalDeathCount desc
```
![2023-06-28 (5)](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/3b3b6ecb-e65e-4ecc-a902-43b20ca2f4f6)



 #### Global Numbers
 ```SQL

Select Sum(new_cases) as Total_cases, Sum(new_deaths) as Total_deaths, Sum(new_Deaths) / SUM(new_cases)*100 as DeathPercentage
from Covid.dbo.CovidDeaths 
where new_cases <>0 and new_deaths <>0 
and continent is not null 
--group by date
order by 1,2
```
![2023-06-28 (2)](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/0e4587cb-aff2-4096-9ff4-dc58e6dd9ff9)


#### Percentage of Population that has received at least one Covid Vaccine
```
Alias for table - 
* de = CovidDeaths
* va = CovidVaccinations
```

```SQL
Select de.continent, de.location, de.date, de.population, va.new_vaccinations, 
Sum(va.new_vaccinations) over (partition by de.location order by de.location,de.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/de.population)*100
from Covid.dbo.CovidDeaths as de join
Covid.dbo.CovidVaccinations as va
ON de.location=va.location and de.date= va.date
where de.continent is not null 
order by 2,3
```
![2023-06-28 (3)](https://github.com/Shreya007data/COVID-19-EXPLORATORY-DATA-ANALYSIS/assets/132162991/ce9b683f-e662-4c45-a6ad-868348f57c9c)

## FINDINGS
* India recorded its first COVID-19 death on March 13, 2020 with a death rate of 1.2%, reaching its highest death rate of 3.4% at a certain point during the pandemic.
*  North America's continent records the highest tragedy with the maximum deaths of people from Covid.
*  Global Numbers of covid were -
  1) Total Cases - 721022091
  2) Total Deaths - 6682164
  3)  Death Percentage - 0.92%
 *  The total number of people vaccinated in India till 31 Dec 2022 is 2,200,989,986.

## CONCLUSION

Through this exploratory data analysis, I gained valuable insights into how the COVID-19 pandemic has affected nations globally. The combination of SQL Server and MS Excel enabled effective data cleaning, querying and analysis, shedding light on the severity of the virus, identifying patterns and trends, and facilitating a deeper understanding of its impact on various countries. 

With this, I want to conclude that every life is important and my deepest condolences to all those affected and lost their close ones in the Covid.


