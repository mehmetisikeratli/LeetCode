

WITH cte AS (
SELECT player_id
    , MIN(event_date) AS install_dt
FROM Activity
GROUP BY player_id
ORDER BY player_id
)
, cte2 AS (
SELECT player_id
    , event_date
    , LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS second_login
    , ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date ASC) AS rn
FROM Activity
ORDER BY player_id
)
, retentionData AS (
SELECT *, DATEDIFF(second_login, event_date) AS diff
FROM cte2
WHERE rn=1 AND DATEDIFF(second_login, event_date)=1
)
SELECT install_dt
    , COUNT(DISTINCT c.player_id) AS installs
    -- , COUNT(DISTINCT rd.player_id) AS Day1_retention_users
    , ROUND( COUNT(DISTINCT rd.player_id) / COUNT(DISTINCT c.player_id) , 2) AS Day1_retention
FROM cte AS c
LEFT JOIN retentionData AS rd
    ON c.install_dt=rd.event_date
GROUP BY install_dt
