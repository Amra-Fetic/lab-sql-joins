USE sakila;
-- 1.List the number of films per category.

SELECT * FROM category AS c
JOIN film_category AS f
ON c.category_id = f.category_id;


-- 2.Retrieve the store ID, city, and country for each store.
SELECT
    s.store_id,
    ci.city,
    co.country
FROM
    store AS s
JOIN
    address AS a ON s.address_id = a.address_id
JOIN
    city AS ci ON a.city_id = ci.city_id
JOIN
    country AS co ON ci.country_id = co.country_id;

-- 3.Calculate the total revenue generated by each store in dollars.
SELECT
    s.store_id,
    SUM(p.amount) AS total_revenue
FROM
    store AS s
JOIN
    staff AS st ON s.store_id = st.store_id
JOIN
    customer AS c ON st.staff_id = c.store_id
JOIN
    rental AS r ON c.customer_id = r.customer_id
JOIN
    payment AS p ON r.rental_id = p.rental_id
GROUP BY
    s.store_id;

-- 4.Determine the average running time of films for each category.
SELECT
    c.category_id,
    c.name AS category_name,
    AVG(f.length) AS average_running_time
FROM
    category AS c
JOIN
    film_category AS fc ON c.category_id = fc.category_id
JOIN
    film AS f ON fc.film_id = f.film_id
GROUP BY
    c.category_id, c.name
ORDER BY
    c.category_id;

-- 5.Identify the film categories with the longest average running time.
SELECT
    c.category_id,
    c.name AS category_name,
    AVG(f.length) AS average_running_time
FROM
    category AS c
JOIN
    film_category AS fc ON c.category_id = fc.category_id
JOIN
    film AS f ON fc.film_id = f.film_id
GROUP BY
    c.category_id, c.name
ORDER BY
    average_running_time DESC;

-- 6. Display the top 10 most frequently rented movies in descending order.
SELECT
    f.film_id,
    f.title AS film_title,
    COUNT(r.rental_id) AS rental_count
FROM
    film AS f
JOIN
    inventory AS i ON f.film_id = i.film_id
JOIN
    rental AS r ON i.inventory_id = r.inventory_id
GROUP BY
    f.film_id, f.title
ORDER BY
    rental_count DESC
LIMIT 10;

-- 7. Determine if "Academy Dinosaur" can be rented from Store 1.

SELECT
    f.title AS film_title,
    s.store_id,
    i.inventory_id,
    COUNT(r.rental_id) AS rental_count
FROM
    film AS f
JOIN
    inventory AS i ON f.film_id = i.film_id
JOIN
    rental AS r ON i.inventory_id = r.inventory_id
JOIN
    store AS s ON i.store_id = s.store_id
WHERE
    f.title = 'Academy Dinosaur'
    AND s.store_id = 1
GROUP BY
    f.title, s.store_id, i.inventory_id;
/* 8.Provide a list of all distinct film titles, along with their availability status in the inventory. 
Include a column indicating whether each title is 'Available' or 'NOT available.' 
Note that there are 42 titles that are not in the inventory, 
and this information can be obtained using a CASE statement combined with IFNULL."*/
SELECT
    f.title AS film_title,
    IFNULL(
        CASE
            WHEN COUNT(i.inventory_id) > 0 THEN 'Available'
            ELSE 'NOT Available'
        END,
        'NOT Available'
    ) AS availability_status
FROM
    film AS f
LEFT JOIN
    inventory AS i ON f.film_id = i.film_id
GROUP BY
    f.title
ORDER BY
    f.title;
