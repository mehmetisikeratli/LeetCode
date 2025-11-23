

WITH primeFootage AS (
SELECT *
    , SUM(square_footage) OVER(PARTITION BY item_type ORDER BY square_footage) AS prime_footage
FROM Inventory
) -- select * from primeFootage
, primeEligible AS (
SELECT 'prime_eligible' AS item_type
    , MAX(prime_footage)
    , FLOOR(500000/MAX(prime_footage)) AS combinations
    , FLOOR(500000/MAX(prime_footage)) * COUNT(DISTINCT item_id) AS item_count
    , 500000 - ( FLOOR(500000/MAX(prime_footage)) * MAX(prime_footage) ) AS left_space
FROM primeFootage
WHERE item_type='prime_eligible'
)
, notPrimeEligible AS (
SELECT 'not_prime' AS item_type
    , MAX(prime_footage)
    , FLOOR( (SELECT left_space FROM primeEligible) /MAX(prime_footage)) AS combinations
    , FLOOR( (SELECT left_space FROM primeEligible) /MAX(prime_footage)) * COUNT(DISTINCT item_id) AS item_count
FROM primeFootage
WHERE item_type='not_prime'
)
SELECT item_type, item_count
FROM primeEligible
UNION ALL
SELECT item_type, item_count 
FROM notPrimeEligible
