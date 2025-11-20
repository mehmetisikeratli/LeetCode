
WITH cte AS (
    SELECT user_id
        , session_id
        , session_type
        , ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY session_start) AS rn
    FROM Sessions
)
, firstSession AS (
    SELECT *
    FROM cte
    WHERE rn=1 AND session_type='Viewer'
)
, laterSessions AS (
SELECT *
FROM cte
WHERE rn!=1 
    AND session_type='Streamer'
    AND user_id IN (SELECT user_id FROM firstSession)
) -- SELECT * FROM laterSessions 
SELECT user_id
    , COUNT(DISTINCT laterSessions.session_id) AS sessions_count
FROM cte
INNER JOIN laterSessions
    USING(user_id)
WHERE user_id IN (SELECT user_id FROM firstSession)
    AND user_id IN (SELECT user_id FROM laterSessions)
GROUP BY user_id
ORDER BY sessions_count DESC, user_id DESC
