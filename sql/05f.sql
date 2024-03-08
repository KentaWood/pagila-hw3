/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */
WITH shared_categories AS (
    SELECT f.title
    FROM film AS f
    JOIN film_category AS fc1 ON f.film_id = fc1.film_id
    JOIN film_category AS fc2 ON fc1.category_id = fc2.category_id
    JOIN film AS fc ON fc2.film_id = fc.film_id
    WHERE fc.title = 'AMERICAN CIRCUS'
    GROUP BY f.title
    HAVING COUNT(DISTINCT fc1.category_id) >= 2
),
shared_actors AS (
    SELECT DISTINCT f2.title
    FROM film AS f1
    JOIN film_actor AS fa1 ON f1.film_id = fa1.film_id
    JOIN actor AS a ON fa1.actor_id = a.actor_id
    JOIN film_actor AS fa2 ON a.actor_id = fa2.actor_id
    JOIN film AS f2 ON fa2.film_id = f2.film_id
    WHERE f1.title = 'AMERICAN CIRCUS'
)
SELECT sc.title
FROM shared_categories AS sc
JOIN shared_actors AS sa ON sc.title = sa.title;

