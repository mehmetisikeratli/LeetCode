

WITH monthly_avg AS (
SELECT DATE_FORMAT(pay_date, '%Y-%m') AS pay_month
    , AVG(amount) AS avg_salary_monthly
FROM Salary
GROUP BY pay_month
)
, department_avg AS (
SELECT DATE_FORMAT(pay_date, '%Y-%m') AS pay_month
    , department_id
    , AVG(amount) OVER(PARTITION BY department_id,DATE_FORMAT(pay_date, '%Y-%m')) AS avg_department_monthly
FROM Salary
LEFT JOIN Employee
    USING(employee_id)
) -- select * from department_avg where department_id=2
SELECT department_avg.pay_month as pay_month
    , department_id
    -- , avg_salary_monthly
    -- , avg_department_monthly
    , CASE WHEN avg_department_monthly>avg_salary_monthly THEN 'higher'
        WHEN avg_department_monthly=avg_salary_monthly THEN 'same'
        WHEN avg_department_monthly<avg_salary_monthly THEN 'lower'
      END AS comparison
FROM department_avg
LEFT JOIN monthly_avg
    USING (pay_month)
GROUP BY   1,2




