

WITH playerScores AS (
    SELECT first_player AS player_id
        , first_score AS score
    FROM Matches
    UNION ALL
    SELECT second_player AS player_id
        , second_score AS score
    FROM Matches
)
, totalScores AS (
SELECT player_id, SUM(score) AS total_score
FROM playerScores
GROUP BY player_id
)
SELECT DISTINCT group_id AS GROUP_ID
    , FIRST_VALUE(t.player_id) OVER(PARTITION BY group_id ORDER BY total_score DESC, t.player_id ASC) AS PLAYER_ID
FROM totalScores AS t
LEFT JOIN Players AS p
    ON t.player_id = p.player_id
