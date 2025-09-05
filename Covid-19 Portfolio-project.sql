Select *
from PortfoiloProject..CovidDeaths
where continent is not null
order by 3,4


Select *
from PortfoiloProject..CovidVaccinations
where continent is not null
order by 3,4


select  location,date,Total_cases, New_cases, Total_deaths, Population
from  PortfoiloProject..CovidDeaths
where continent is not null
order by 1,2

-- Total Cases VS Total Deaths

select  location,date,Total_cases,Total_deaths, (Total_Deaths/Total_Cases)*100 AS DeathPercentages
from  PortfoiloProject..CovidDeaths
where Location like '%states%' 
order by 1,2


-- Total_Cases VS Population
-- Total Percentage of Population that Got Covid

select  location,date,population,Total_cases, (Total_Cases/Population)*100 AS PercentPopulationInfected 
from  PortfoiloProject..CovidDeaths
--where Location like '%states%' 
where continent is not null
order by 1,2

-- Countries With Highest Infection Rate Compared to Population
select  location,population,MAX(Total_cases),  Max((Total_Cases/Population))*100 AS	PercentPopulationInfected
from  PortfoiloProject..CovidDeaths
--where Location like '%states%' 
where continent is not null
group by Location, Population
order by PercentPopulationInfected Desc


--Countries with Highest Death Count Per Population

select  location, MAX(Cast (Total_Deaths as int)) as TotalDeathCount
from PortfoiloProject ..CovidDeaths
--where Location like '%states%' 
where continent is not null
group by Location
order by TotalDeathCount  Desc

-- BREAKING THINGS DOWN BY CONTINENT

select  continent, MAX(Cast (Total_Deaths as int)) as TotalDeathCount
from PortfoiloProject ..CovidDeaths
--where Location like '%states%' 
where continent is not null
group by continent
order by TotalDeathCount  Desc

--GLOBAL DEATH
select Date, sum(new_cases) as Total_Cases, sum (cast(new_deaths as int )) as Total_Deaths, sum(cast(new_deaths as int ))/sum(new_cases) * 100 as DeathPercentage
from PortfoiloProject  ..CovidDeaths
where continent is not null
group by Date
order by 1,2


--Total Global Cases and Deaths

select sum(new_cases) as Total_Cases, sum (cast(new_deaths as int )) as Total_Deaths, sum(cast(new_deaths as int ))/sum(new_cases) * 100 as DeathPercentage
from PortfoiloProject  ..CovidDeaths
where continent is not null
--group by Date
order by 1,2

--Joining CovidDeaths and  CovidVaccinations
-- Total Population Vs Vaccination
select *
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations vac 
on dea.location = Vac.location
and dea.date = Vac.date


-- Total Population Vs Vaccination
select dea.continent, dea.location, dea.Population , Vac.new_vaccinations
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
order by 2,3

-- Total number of people vaccinated by continent 
select dea.continent, dea.location, dea.Date , dea.Population , Vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as PeopleVaccinated
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
order by 2,3

-- People Vaccinated in each Continent

select dea.continent, dea.location, dea.Date , dea.Population , Vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as PeopleVaccinated
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
order by 2,3

-- Using cities 

with popvsvac (continent, Location,Date,Population,new_vaccinations,peoplevaccinated )
as 
(
select dea.continent, dea.location, dea.Date , dea.Population , Vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as PeopleVaccinated
--(peoplevaccinated/Population) * 100
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
--order by 2,3
)
select * , (Peoplevaccinated/population) *100
from popvsvac


--TEMP TABLE
Drop Table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar (255),
location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
peoplevaccinated numeric,
)
insert  into #percentpopulationvaccinated

select dea.continent, dea.location, dea.Date , dea.Population , Vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as PeopleVaccinated
--(peoplevaccinated/Population) * 100
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
--order by 2,3

select * , (Peoplevaccinated/population) *100
from #percentpopulationvaccinated

create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.Date , dea.Population , Vac.new_vaccinations
,sum(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as PeopleVaccinated
--(peoplevaccinated/Population) * 100
from PortfoiloProject ..CovidDeaths dea
join PortfoiloProject ..CovidVaccinations Vac
on dea.location = Vac.location
and dea.date = Vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated