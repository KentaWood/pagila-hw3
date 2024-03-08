/*
 * Compute the country with the most customers in it. 
 */
SELECT
    co.country
FROM
    customer cu
JOIN
    address a ON cu.address_id = a.address_id
JOIN
    city ci ON a.city_id = ci.city_id
JOIN
    country co ON ci.country_id = co.country_id
GROUP BY
    co.country_id, co.country
ORDER BY
    COUNT(*) DESC
LIMIT 1;

