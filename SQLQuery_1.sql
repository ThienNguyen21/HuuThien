Select Location, date, total_cases, total_deaths, (Convert(Float, Total_deaths)/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location Like '%state%'
order by 1,2



SELECT total_deaths, total_cases, (total_deaths/total_cases)
From PortfolioProject..CovidDeaths
---

Select Location, date, total_cases, population, (Convert(Float,total_cases)/Population)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location Like '%state%'
order by 1,2

----
Select Continent, MAX(Total_deaths) As totaldeathscount
From PortfolioProject..CovidDeaths
Where Continent is not null
Group By Continent
Order By totaldeathscount Desc

----
Select  Sum(New_cases) as Totalcases, Sum(New_deaths) as totaldeaths, Sum(cast(New_deaths as float))/Sum(New_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
order by 1,2
-----

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( Convert(int, new_vaccinations)) Over(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.Continent is not null
Order by 2,3

----
WITH popvsvac 
AS
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM( Convert(int, new_vaccinations)) Over(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.Continent is not null
---Order by 2,3
)
Select *, (Cast(RollingPeopleVaccinated as float)/population)*100
From popvsvac

----
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-----
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
