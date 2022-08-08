/*1. Which actor_id has the most number of unique film_id records in the dvd_rentals.film_actor table?*/
SELECT
  actor_id,
  COUNT(DISTINCT film_id)
FROM dvd_rentals.film_actor
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


/*2. How many distinct fid values are there for the 3rd most common price value in the dvd_rentals.nicer_but_slower_film_list table?*/
WITH PRICE AS (
SELECT price, COUNT(PRICE) FROM   dvd_rentals.nicer_but_slower_film_list
GROUP BY PRICE
ORDER BY COUNT desc
OFFSET 2)

SELECT * FROM PRICE

/*3. How many unique country_id values exist in the dvd_rentals.city table?*/
SELECT COUNT(DISTINCT country_id)  FROM dvd_rentals.city