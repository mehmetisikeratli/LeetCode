

with cte as (
select *
    , SUM(salary) OVER(ORDER BY salary, employee_id) AS total_senior_salaries
from Candidates
where experience='Senior'
)
, cte2 as (
select *
    , SUM(salary) OVER(ORDER BY salary, employee_id) AS total_junior_salaries
from Candidates
where experience='Junior'
)
select if(experience is null ,'Senior' , experience) as experience
    , count(distinct employee_id) as accepted_candidates
from cte 
where total_senior_salaries<70000
union all 
select if(experience is null ,'Junior' , experience) as experience
    , count(distinct employee_id) as accepted_candidates
from cte2
where total_junior_salaries < (70000 - (select if(max(total_senior_salaries) is null,0,max(total_senior_salaries)) from cte where total_senior_salaries<70000))
;
