-- 1. What is the name of the category with the highest category_id in the dvd_rentals.category table?
SELECT
    name,
    category_id
FROM
    dvd_rentals.category
ORDER BY
    category_id desc 
    
-- 2. For the films with the longest length, what is the title of the “R” rated film with the lowest replacement_cost in dvd_rentals.film table?
SELECT
    title,
    replacement_cost,
    length,
    rating
from
    dvd_rentals.film
ORDER BY
    length desc,
    replacement_cost
LIMIT
    10 
    
-- 3. Who was the manager of the store with the highest total_sales in the dvd_rentals.sales_by_store table?
SELECT
    manager,
    total_sales
FROM
    dvd_rentals.sales_by_store
ORDER BY
    total_sales desc 
    
-- 4. What is the postal_code of the city with the 5th highest city_id in the dvd_rentals.address table?
SELECT
    city_id,
    postal_code
FROM
    dvd_rentals.address
ORDER BY
    city_id desc
LIMIT
    5