--firstly bring in rental_date as a field from the table joins
DROP TABLE IF EXISTS complete_joint_dataset_with_rental_date;
CREATE TEMP TABLE complete_joint_dataset_with_rental_date AS
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  category.name AS category_name,
  rental.rental_date
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id;
/*
-- Finally perform group by aggregations on category_name and customer_id
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset_with_rental_date
-- note the different filter here!
WHERE customer_id = 3
GROUP BY
  customer_id,
  category_name
ORDER BY
  customer_id,
  rental_count DESC,
  latest_rental_date DESC;*/
  
  DROP TABLE IF EXISTS category_rental_counts;
CREATE TEMP TABLE category_rental_counts AS
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset_with_rental_date
GROUP BY
  customer_id,
  category_name;

/*
-- profile just customer_id = 1 values sorted by desc rental_count
SELECT *
FROM category_rental_counts
WHERE customer_id = 1
ORDER BY
  rental_count DESC;
*/  
  
  DROP TABLE IF EXISTS customer_total_rentals;
CREATE TEMP TABLE customer_total_rentals AS
SELECT
  customer_id,
  SUM(rental_count) AS total_rental_count
FROM category_rental_counts
GROUP BY customer_id;

/*
-- show output for first 5 customer_id values
SELECT *
FROM customer_total_rentals
WHERE customer_id <= 5
ORDER BY customer_id;*/

DROP TABLE IF EXISTS average_category_rental_counts;
CREATE TEMP TABLE average_category_rental_counts AS
SELECT
  category_name,
  AVG(rental_count) AS avg_rental_count
FROM category_rental_counts
GROUP BY
  category_name;

-- output the entire table by desc avg_rental_count
/*
SELECT *
FROM average_category_rental_counts
ORDER BY
  avg_rental_count DESC;
  */

-- getting some of the data with percentile information. But, it maybe a little weird because the data showd that they are in the top 1% of watchers if they are 1 percentile
 DROP TABLE IF EXISTS customer_category_percentiles;
CREATE TEMP TABLE customer_category_percentiles AS
SELECT
  customer_id,
  category_name,
  -- use ceiling to round up to nearest integer after multiplying by 100
  CEILING(
    100 * PERCENT_RANK() OVER (
      PARTITION BY category_name
      ORDER BY rental_count DESC
    )
  ) AS percentile
FROM category_rental_counts;

-- inspect top 2 records for customer_id = 1 sorted by ascending percentile
/*
SELECT *
FROM customer_category_percentiles
WHERE customer_id = 1
ORDER BY customer_id, percentile
LIMIT 2;
*/


-- joined all of the data together
DROP TABLE IF EXISTS customer_category_joint_table;
CREATE TEMP TABLE customer_category_joint_table AS
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t1.latest_rental_date,
  t2.total_rental_count,
  t3.avg_rental_count,
  t4.percentile,
  t1.rental_count - t3.avg_rental_count AS average_comparison,
  -- round to nearest integer for percentage after multiplying by 100
  ROUND(100 * t1.rental_count / t2.total_rental_count) AS category_percentage
FROM category_rental_counts AS t1
INNER JOIN customer_total_rentals AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN average_category_rental_counts AS t3
  ON t1.category_name = t3.category_name
INNER JOIN customer_category_percentiles AS t4
  ON t1.customer_id = t4.customer_id
  AND t1.category_name = t4.category_name;

-- inspect customer_id = 1 top 5 rows sorted by percentile
SELECT *
FROM customer_category_joint_table
WHERE customer_id = 1
ORDER BY percentile
limit 5;


-- checking information_schema.columns
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name in ('customer_total_rentals', 'category_rental_counts');