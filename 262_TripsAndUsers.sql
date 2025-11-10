
select request_at as Day, round(sum(IF(Status != 'completed' , 1,0)) / count(id) , 2) as 'Cancellation Rate'
from trips
where request_at between '2013-10-01' and '2013-10-03'
    and client_id NOT IN (select users_id from Users where banned = 'Yes')
    and driver_id NOT IN (select users_id from Users where banned = 'Yes')
group by request_at
