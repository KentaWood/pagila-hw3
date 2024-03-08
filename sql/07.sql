/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
SELECT DISTINCT CONCAT(a.first_name, ' ', a.last_name) AS "Actor Name"
FROM actor AS a
JOIN film_actor AS fa1 ON a.actor_id = fa1.actor_id
JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id
JOIN film_actor AS fa3 ON fa2.actor_id = fa3.actor_id
JOIN film_actor AS fa4 ON fa3.film_id = fa4.film_id
JOIN actor AS b ON fa4.actor_id = b.actor_id
WHERE b.first_name = 'RUSSELL' AND b.last_name = 'BACALL'
AND a.actor_id NOT IN (
    SELECT DISTINCT a.actor_id
    FROM actor AS a
    JOIN film_actor AS fa1 ON a.actor_id = fa1.actor_id
    JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id
    JOIN actor AS b ON fa2.actor_id = b.actor_id
    WHERE b.first_name = 'RUSSELL' AND b.last_name = 'BACALL'
)
ORDER BY "Actor Name";

