/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
WITH RankedRentals AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        f.film_id,
        fc.category_id,
        r.rental_date,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY r.rental_date DESC) as rental_rank
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    WHERE fc.category_id = (SELECT category_id FROM category WHERE name = 'Action') -- assuming the category 'Action' exists
), ActionFanatics AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        COUNT(film_id) FILTER (WHERE category_id = (SELECT category_id FROM category WHERE name = 'Action')) as action_movie_count
    FROM RankedRentals
    WHERE rental_rank <= 5
    GROUP BY customer_id, first_name, last_name
)
SELECT
    customer_id,
    first_name,
    last_name
FROM ActionFanatics
WHERE action_movie_count >= 4
ORDER BY customer_id ASC;

