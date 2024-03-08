/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */
SELECT f2.title
FROM film AS f1
JOIN film_actor AS fa1 ON f1.film_id = fa1.film_id
JOIN actor AS a ON fa1.actor_id = a.actor_id
JOIN film_actor AS fa2 ON a.actor_id = fa2.actor_id
JOIN film AS f2 ON fa2.film_id = f2.film_id
WHERE f1.title = 'AMERICAN CIRCUS'
GROUP BY f2.title
HAVING COUNT(DISTINCT a.actor_id) >= 2
ORDER BY f2.title;
