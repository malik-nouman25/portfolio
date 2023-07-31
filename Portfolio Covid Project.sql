Select *
From portfolio_db..CovidDeaths
order by 3,4

Select *
From portfolio_db..CovidVaccinations
order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
From portfolio_db..CovidDeaths
order by 1,2

-- looking at the total cases vs total death
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpersentage
From portfolio_db..CovidDeaths
where location like '%Pakistan%'
order by 1,2

Select location,population,date,total_cases,(total_cases/population)*100 as deathpersentagepopulation
From portfolio_db..CovidDeaths
--where location like '%Pakistan%'
order by 1,2

--lookinf for the country with the highest rate of infection

Select location,population,MAX(total_cases)as highestInfaction,MAX((total_cases/population)*100 )as PersentpopulationInfected
From portfolio_db..CovidDeaths
--where location like '%Pakistan%'
Group by location,population
order by PersentpopulationInfected desc

-- showing coungtry with highest death count
Select location,MAX(CAST(total_deaths AS int)) as totaldeathCount
From portfolio_db..CovidDeaths
--where location like '%Pakistan%'
WHERE continent is not null
Group by location
order by totaldeathCount desc

-- showing continet with the highest death count per population
--global Number

Select sum(new_cases)as totalcases,sum(cast(new_deaths as int))as totaldeath,(sum(cast(new_deaths as int))/sum(new_cases))*100 as deathpersentage
From portfolio_db..CovidDeaths
--where location like '%Pakistan%'
WHERE continent is not null
--group by date
order by 1,2


--looking at the total population vs vaccination
with popvsvac (Continent, Location, Date, Population,new_vaccinations, rollingpeople)
as(

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum (cast(vac.new_vaccinations AS int) )over (partition by dea.location order by dea.location,dea.date)as rollingpeople
from portfolio_db..CovidDeaths dea
join portfolio_db..CovidVaccinations vac
on dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)

select*,(rollingpeople/Population)*100
from popvsvac
 --use cte
