/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
WITH recent_rentals AS (
    SELECT
        r.customer_id,
        r.inventory_id,
        r.rental_date,
        f.film_id,
        f.title,
        STRING_AGG(cat.name, ', ') AS categories,
        ROW_NUMBER() OVER (PARTITION BY r.customer_id ORDER BY r.rental_date DESC) AS rn
    FROM
        rental AS r
    JOIN
        inventory AS i ON r.inventory_id = i.inventory_id
    JOIN
        film AS f ON i.film_id = f.film_id
    JOIN
        film_category AS fc ON f.film_id = fc.film_id
    JOIN
        category AS cat ON fc.category_id = cat.category_id
    GROUP BY
        r.customer_id, r.inventory_id, r.rental_date, f.film_id, f.title
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM
    customer AS c
JOIN
    recent_rentals AS rr ON c.customer_id = rr.customer_id
WHERE
    rr.rn <= 5
    AND 'Action' IN (SELECT UNNEST(string_to_array(rr.categories, ', ')))
GROUP BY
    c.customer_id, c.first_name, c.last_name
HAVING
    COUNT(*) >= 4
ORDER BY
    c.customer_id;
