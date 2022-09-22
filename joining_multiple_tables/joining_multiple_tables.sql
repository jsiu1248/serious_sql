SELECT * FROM dvd_rentals.film_actor
SELECT * FROM dvd_rentals.actor


-- Please have a go at analyzing the required table joins using our framework above to inspect the relationships for film_id and actor_id in the dvd_rentals.film_actor table.

-- What is the relationship between the two columns?
-- Figuring out if film_id has multiple rows
-- Records show only 21 film_ids have 1 record. So, there are many film_ids that have multiple records.
WITH base_counts AS (
SELECT
  film_id,
  COUNT(*) AS record_count
FROM dvd_rentals.film_actor
GROUP BY film_id
)
SELECT
  record_count,
  COUNT(DISTINCT film_id) as unique_film_id_values
FROM base_counts
GROUP BY record_count
ORDER BY record_count;

-- Figuring out if actor_id has multiple rows
-- Interestingly enough actors have been in at least 14 movies. So, they have multiple records
-- The CTE counts the amount of times for each actor_id
WITH base_counts AS (
SELECT actor_id, COUNT(*) AS record_count FROM dvd_rentals.film_actor
GROUP BY actor_id)

-- count number of actor ids that have the same number of record count
SELECT record_count, COUNT(DISTINCT actor_id) as unique_actor_id_values
FROM base_counts
GROUP BY record_count
ORDER BY record_count


-- What contextual hypotheses do we have about the data?
-- How can we validate these assumptions?
-- Many to many relationship

-- What is the distribution of foreign keys within each table?
-- How many unique foreign key values exist in each table?



SELECT film_id, actor_id FROM dvd_rentals.film_actor

SELECT film_id, actor_id FROM dvd_rentals.film_actor