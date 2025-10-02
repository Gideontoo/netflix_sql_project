	select *
	from netflix

-- The number of entries
	select count(*)
	from netflix

-- The different types of show_type
	select distinct show_type
	from netflix

-- The most common rating for movies and TV shows
	
	with t1 as
	(select show_type, rating, count(*) rating_count, rank() 
	       over(partition by show_type order by count(*) desc)
	from netflix
	group by 1,2)
	select show_type,rating, rating_count
	from t1
	where rank = 1

-- All movies released in a specific year (for example 2020)
	select title
	from netflix
	where show_type = 'Movie' and
	release_year = 2020

-- Top countries with the most content (example top 5 countries)
	select 	unnest(string_to_array(country,',')) updated_country, count(*) content_count
	from netflix
	where country is not null
	group by 1
	order by 2 desc
	limit 5

-- Identify the longest movie
	
	select show_type,title, split_part(duration, ' ', 1):: numeric movie_duration
	from netflix
	where show_type = 'Movie' and duration is not null
	order by 3 desc
	limit 1

-- Content added in a given duration of time (example in the last 7 years)
	select *
	from netflix
	where to_date(date_added,'month dd,yyyy') >= current_date - interval '7 years'
	
-- All the movies/TV Shows by a given director (example Kirsten Johnson)
	select show_type,title, director
	from netflix
	where director ilike '%Kirsten Johnson%'

-- TV Shows with more than a given set of seasons (example more than 7 seasons)

	select *
	from netflix
	where show_type = 'TV Show' and
	split_part(duration, ' ', 1):: numeric > 7
	order by duration desc


-- Number of content items in each genre

	select unnest(string_to_array(listed_in,',')), count(*)
	from netflix
	group by 1
	order by 2 desc

-- The average number of content released each year by a specific country (for example India)

	select extract(year from to_date(date_added,'month dd,yyyy')), count(*) content_count,
	round(count(*) :: 
	numeric/(select count(*) from netflix where country = 'India'):: numeric* 100,2)
	from netflix
	where country = 'India'
	group by 1
	order by 3 desc

-- The average content released each year in the United States
	select extract(year from to_date(date_added,'month dd,yyyy')), count(*) content_count,
	round(count(*) :: numeric / 
	(select count(*) from netflix  where country = 'United States') :: numeric * 100,2)
	from netflix
	where country = 'United States'
	group by 1
	order by 2 desc

-- List all movies that belong to a particular genre (for example documentaries)

	select title
	from netflix
	where show_type = 'Movie'
	and listed_in Ilike '%Documentaries%'

-- All movies without a director
	select title
	from netflix
	where director is null

-- List of movies a given actor appeared in during a given period of time (example 'Salman Khan' in the last 10 years)
	select *
	from netflix
	where casts like '%Salman Khan%' and
	release_year> extract(year from current_date) - 10
	
-- Top 10 actors who appeared in the highest number of movies in a given country (example United States)

	select  unnest(string_to_array(casts,',')) actors, count(*)
	from netflix
	where country ilike  '%United States%' and 
	casts is not null
	group by 1
	order by 2 desc
	limit 10

-- Movie rating based on keywords 'Kill' and 'Violence' as rated

	with t1 as
	(select title, show_type, 
	case 
	when description ilike '%kill%' or description ilike '%violence%'
	then 'over 18'
	else 'under 18'
	end as rating
	from netflix)

	select rating, count(*)
	from t1
	group by 1
	order by 2 desc
















	











	

	