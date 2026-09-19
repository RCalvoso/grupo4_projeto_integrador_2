-- Q1

-- Quantas linhas temos na tablea de life_excpectancy?
SELECT COUNT(1) QTT
  FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`

-- Qual é o maior ano (coluna YEARS) que temos na tabela
SELECT MAX(year) max_year
  FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`

-- Quantidade de linhas de dados por ano (coluna YEARS):
SELECT year, 
       count(1) quantidade
  FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`
 GROUP BY year
 ORDER BY year desc

-- Amostra de dados de 100 linhas com toda as colunas...
SELECT *
 FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`
 LIMIT 100

-- Agrupar ano e país e obter as médias de meninos e meninas
SELECT
  year,
  country_name,
  avg(life_expectancy_female) girls,
  avg(life_expectancy_male) boys
FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`
GROUP BY
  year,
  country_name;

-- Agrupar ano e país e obter as médias de meninos e meninas
SELECT
  year,
  country_name,
  avg(life_expectancy_female) girls,
  avg(life_expectancy_male) boys
FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`
WHERE country_code = "BR"
GROUP BY
  year,
  country_name;


-- Agrupar ano e país e obter as médias de meninos e meninas com expectativa de vida > 90 anos
SELECT
  year,
  country_name,
  life_expectancy,
  avg(life_expectancy_female) girls,
  avg(life_expectancy_male) boys
FROM
  `bigquery-public-data.census_bureau_international.mortality_life_expectancy`
GROUP BY
  year,
  country_name,
  life_expectancy
HAVING life_expectancy > 90;


-- Chamados da prefeitura
select *
  from `bigquery-public-data.austin_311.311_service_requests`
 limit 100


-- Quantidade de chamados por fonte (origem)
 select source,
       count(1) qtd
  from `bigquery-public-data.austin_311.311_service_requests`
 group by source
 order by qtd desc
 limit 100



-- Em quanto tempo os chamados são fechados??
select TIMESTAMP_DIFF(close_date, created_date, DAY) days_interval,
       count(1)  qtd
  from `bigquery-public-data.austin_311.311_service_requests`
 where created_date is not null
   and close_date is not null
 group by days_interval
 order by qtd desc
 limit 100

-- Max year...
select max(year)
  from `bigquery-public-data.census_bureau_international.mortality_life_expectancy`

 -- Expectativa de vida para os países com maior território... para o maior ano...
select country.country_name, 
       country.country_area, 
       life.life_expectancy
from `bigquery-public-data.census_bureau_international.country_names_area` country,
     `bigquery-public-data.census_bureau_international.mortality_life_expectancy` life
where country.country_code = life.country_code -- Inner join, key (chave), id
  and life.year = (select max(year)
                     from `bigquery-public-data.census_bureau_international.mortality_life_expectancy`) -- sub query
order by country.country_area desc
limit 100

-- Expectativa de vida para os países com maior território... para 2025...
select country.country_name, 
       country.country_area, 
       life.life_expectancy
from `bigquery-public-data.census_bureau_international.country_names_area` country,
     `bigquery-public-data.census_bureau_international.mortality_life_expectancy` life
where country.country_code = life.country_code -- Inner join, key (chave), id
  and life.year = 2025
order by country.country_area desc
limit 100


-- 
select distinct c.country_name,
                c.country_area,
                avg(pop.population) avg_pop,
                avg(pop.age) avg_age
  from `bigquery-public-data.census_bureau_international.country_names_area` c,
       `bigquery-public-data.census_bureau_international.midyear_population_agespecific` pop
 where c.country_code = pop.country_code -- inner join, id das tabelas...
   and pop.year = (select max(year)
                     from `bigquery-public-data.census_bureau_international.midyear_population_agespecific`) -- sub query
 group by c.country_name, c.country_area
 order by c.country_area desc
 limit 100

 SELECT title,
       release_year,
       locations,
       IFNULL(fun_facts,"None") fun_facts,
       production_company,
       distributor,
       director,
       IFNULL(writer,"Unknow") writer,
       actor_1, -- dado desnormalizado... OK para DW
       actor_2,
       actor_3
FROM `bigquery-public-data.san_francisco_film_locations.film_locations`
WHERE title like '%War%'
  AND locations is not null
LIMIT 100

