

WITH cte AS (
SELECT id
    , company
    , salary
    , CAST( ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary ASC) AS SIGNED) AS row_nr_asc
    , CAST( ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary DESC) AS SIGNED) AS row_nr_desc
FROM Employee
ORDER BY company, salary
)
SELECT id
    , company
    , salary
FROM cte
WHERE ABS(row_nr_asc - row_nr_desc) <= 1
GROUP BY company, salary
ORDER BY company, salary
;


