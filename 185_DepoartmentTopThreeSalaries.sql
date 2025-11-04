

select Department,Employee,Salary from (
    select
        d.name as Department
        , e.name as Employee
        , e.Salary as Salary
        , dense_rank() over(partition by d.name order by Salary desc) as dense_rnk
    from employee e
    left join department d
        on d.id = e.departmentId
) as wind
where dense_rnk <= 3
;


