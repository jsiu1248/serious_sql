/*1. Which actor_id has the most number of unique film_id records in the dvd_rentals.film_actor table?*/
SELECT
    actor_id,
    COUNT(DISTINCT film_id)
FROM
    dvd_rentals.film_actor
GROUP BY
    1
ORDER BY
    2 DESC
LIMIT
    5;

/*2. How many distinct fid values are there for the 3rd most common price value in the dvd_rentals.nicer_but_slower_film_list table?*/
WITH PRICE AS (
    SELECT
        price,
        COUNT(PRICE)
    FROM
        dvd_rentals.nicer_but_slower_film_list
    GROUP BY
        PRICE
    ORDER BY
        COUNT desc OFFSET 2
)
SELECT
    *
FROM
    PRICE
    
/*3. How many unique country_id values exist in the dvd_rentals.city table?*/
SELECT
    COUNT(DISTINCT country_id)
FROM
    dvd_rentals.city

/*4. What percentage of overall total_sales does the Sports category make up in the dvd_rentals.sales_by_film_category table?*/
/*Be careful of group by and using over together.*/
SELECT
    category,
    ROUND(100 * total_sales / SUM(total_sales) OVER(), 2) as percent
FROM
    dvd_rentals.sales_by_film_category
    
/*5. What percentage of unique fid values are in the Children category in the dvd_rentals.film_list table?*/
SELECT
    category,
    ROUND(
        100 * count(DISTINCT fid) / sum(count(DISTINCT fid)) OVER(),
        2
    )
FROM
    dvd_rentals.film_list
GROUP BY
    category