

WITH e AS (
SELECT id
    , month
    , salary
FROM Employee
)
, recentMonth AS (
SELECT id
    , MAX(month) AS recent_month
FROM Employee 
GROUP BY id
)
, prepData AS (
SELECT e1.id AS id
    , e1.month AS e1_month
    , e2.month AS e2_month
    -- , e2.salary
    , CASE WHEN e1.month-e2.month BETWEEN 0 AND 2 THEN e2.salary END AS new_salary
FROM e AS e1
JOIN e AS e2
    ON e1.id = e2.id
    AND e2.month BETWEEN e1.month - 2 AND e1.month
JOIN recentMonth
    ON e1.id=recentMonth.id
WHERE e1.month!=recentMonth.recent_month
    -- AND e1.id=1 
ORDER BY e1.month DESC, e2.month DESC
)
SELECT id
    , e1_month AS month
    , SUM(new_salary) AS Salary
FROM prepData
GROUP BY id, e1_month
ORDER BY id, e1_month DESC



with t1 as (
    select id, month, 
    sum(salary) over (partition by id order by month range 2 preceding) as salary,
    dense_rank() over (partition by id order by month desc) month_no
    from employee
)

select id, month, salary 
from t1 
where month_no > 1 
order by id, month desc 
