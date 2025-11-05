

WITH RECURSIVE new_table AS (
    SELECT post_id
        , content
        , 1 AS x
        , LENGTH(content) - LENGTH(REPLACE(content,' ','')) +1 AS len
        , SUBSTRING_INDEX(SUBSTRING_INDEX(content, ' ', 1), ' ', -1) AS words
    FROM Posts
    UNION ALL
    SELECT post_id
        , content
        , x+1 AS x
        , len
        , SUBSTRING_INDEX(SUBSTRING_INDEX(content, ' ', x+1), ' ', -1) AS words
    FROM new_table
    WHERE x<len
) -- SELECT * FROM new_table WHERE post_id=2
, cte AS (
SELECT *
FROM new_table AS n
LEFT JOIN Keywords AS k
    ON LOWER(n.words) = LOWER(k.word)
ORDER BY post_id, x
) -- SELECT * FROM cte WHERE post_id=2
SELECT post_id
    -- , GROUP_CONCAT(words,',')
    , IFNULL(GROUP_CONCAT(DISTINCT topic_id ORDER BY topic_id ASC,',') , 'Ambiguous!') AS topic
FROM cte 
GROUP BY post_id
