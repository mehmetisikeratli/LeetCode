# Write your MySQL query statement below

WITH cte AS (
SELECT *
    , SUM(salary) OVER(PARTITION BY experience ORDER BY salary ASC) AS cum_sum
FROM Candidates
)
, seniorList AS (
SELECT *
FROM cte
WHERE experience='Senior'
    AND cum_sum<= 70000
)
, limits AS (SELECT 70000-COALESCE( MAX(cum_sum),0) AS new_limit FROM seniorList)
, juniorList AS (
SELECT employee_id
FROM cte
WHERE experience='Junior'
    AND cum_sum <= (SELECT new_limit FROM limits)
) 
SELECT employee_id
FROM seniorList
UNION ALL
SELECT employee_id
FROM juniorList

