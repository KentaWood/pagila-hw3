/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */
WITH FilmRevenue AS (
    SELECT
        fa.actor_id,
        f.film_id,
        SUM(p.amount) AS revenue
    FROM
        payment p
        JOIN rental r ON p.rental_id = r.rental_id
        JOIN inventory i ON r.inventory_id = i.inventory_id
        JOIN film f ON i.film_id = f.film_id
        JOIN film_actor fa ON f.film_id = fa.film_id
    GROUP BY
        fa.actor_id, f.film_id
), RankedFilms AS (
    SELECT
        a.actor_id,
        a.first_name,
        a.last_name,
        fr.film_id,
        f.title,
        ROW_NUMBER() OVER (PARTITION BY a.actor_id ORDER BY fr.revenue DESC, f.film_id) AS rank, -- Using ROW_NUMBER() and ordering by revenue, then film_id
        fr.revenue
    FROM
        FilmRevenue fr
        JOIN actor a ON fr.actor_id = a.actor_id
        JOIN film f ON fr.film_id = f.film_id
)
SELECT
    actor_id,
    first_name,
    last_name,
    film_id,
    title,
    rank,
    revenue
FROM
    RankedFilms
WHERE
    rank <= 3
ORDER BY
    actor_id, rank;
