

WITH averages AS (
SELECT team
    , AVG(workload) AS avg_workload
FROM Project
LEFT JOIN Employees
    USING(employee_id)
GROUP BY team
)
SELECT Project.employee_id AS EMPLOYEE_ID
    , project_id AS PROJECT_ID
    , name AS EMPLOYEE_NAME
    , workload AS PROJECT_WORKLOAD
FROM Project
LEFT JOIN Employees 
    USING(employee_id)
LEFT JOIN averages
    ON Employees.team=averages.team
WHERE workload>averages.avg_workload
ORDER BY 1,2
