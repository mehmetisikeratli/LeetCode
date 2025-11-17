

WITH cte AS (
SELECT user1
    , user2
FROM Friends
UNION ALL 
SELECT user2 AS user1
    , user1 AS user2
FROM Friends
) 
SELECT user1
    , ROUND( COUNT(DISTINCT user2) / (SELECT COUNT(DISTINCT user1) FROM cte) * 100 , 2)  AS percentage_popularity
FROM cte
GROUP BY user1
ORDER BY user1 


