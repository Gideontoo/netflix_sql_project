# Netflix movies and TV Shows Analysis using SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
Sourced from kaggle

**Dataset Link:**[Movie Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

```
## Analysis and findings
### 1.The different types of shows available on Netflix
	
```sql
	select distinct show_type
	from netflix
```

### 2.The most common rating for movies and TV shows
```sql
	with t1 as
	(select show_type, rating, count(*) rating_count, rank() 
	       over(partition by show_type order by count(*) desc)
	from netflix
	group by 1,2)
	select show_type,rating, rating_count
	from t1
	where rank = 1
```

### 3.All movies released in a specific year (for example 2020)
```sql	
	select title
	from netflix
	where show_type = 'Movie' and
	release_year = 2020
```

### 4.Top countries with the most content (example top 5 countries)
```sql
	select 	unnest(string_to_array(country,',')) updated_country, count(*) content_count
	from netflix
	where country is not null
	group by 1
	order by 2 desc
	limit 5
```

### 5.Identify the longest movie
	
```sql
	select show_type,title, split_part(duration, ' ', 1):: numeric movie_duration
	from netflix
	where show_type = 'Movie' and duration is not null
	order by 3 desc
	limit 1
```

### 6.Content added in a given duration of time (example in the last 7 years)
```sql	
	select *
	from netflix
	where to_date(date_added,'month dd,yyyy') >= current_date - interval '7 years'
```
### 7.All the movies/TV Shows by a given director (example Kirsten Johnson)
```sql	
	select show_type,title, director
	from netflix
	where director ilike '%Kirsten Johnson%'
```

### 8.TV Shows with more than a given set of seasons (example more than 7 seasons)
```sql
	select *
	from netflix
	where show_type = 'TV Show' and
	split_part(duration, ' ', 1):: numeric > 7
	order by duration desc
```

### 9.Number of content items in each genre
```sql
	select unnest(string_to_array(listed_in,',')), count(*)
	from netflix
	group by 1
	order by 2 desc
```

### 10.The average number of content released each year by a specific country (for example India)
``` sql
	select extract(year from to_date(date_added,'month dd,yyyy')), count(*) content_count,
	round(count(*) :: 
	numeric/(select count(*) from netflix where country = 'India'):: numeric* 100,2)
	from netflix
	where country = 'India'
	group by 1
	order by 3 desc
```

### 11.The average content released each year in the United States
```sql	
	select extract(year from to_date(date_added,'month dd,yyyy')), count(*) content_count,
	round(count(*) :: numeric / 
	(select count(*) from netflix  where country = 'United States') :: numeric * 100,2)
	from netflix
	where country = 'United States'
	group by 1
	order by 2 desc
```

### 12.List all movies that belong to a particular genre (for example documentaries)
```sql
	select title
	from netflix
	where show_type = 'Movie'
	and listed_in Ilike '%Documentaries%'
```
