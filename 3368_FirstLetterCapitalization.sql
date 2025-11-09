

WITH RECURSIVE new_table AS (
    SELECT content_id
        , content_text
        , 1 AS x
        , LENGTH(content_text) - LENGTH(REPLACE(content_text, ' ','')) + 1 AS n
        , SUBSTRING_INDEX(SUBSTRING_INDEX(content_text, " ", 1), ' ', -1) AS words
    FROM user_content
    UNION ALL
    SELECT content_id
        , content_text
        , x+1
        , n
        , SUBSTRING_INDEX(SUBSTRING_INDEX(content_text, " ", x+1), ' ', -1) AS words
    FROM new_table
    WHERE x<n
)
SELECT content_id
    , content_text AS original_text
    -- , LOWER(words)
    , GROUP_CONCAT(CONCAT( UPPER(LEFT(words,1)) , LOWER(SUBSTRING(words,2)) ) ORDER BY x SEPARATOR ' ' ) AS converted_text
    -- , CONCAT( UPPER(LEFT(words,1)) , LOWER(SUBSTRING(words,2)) ) AS new_words
FROM new_table
-- WHERE content_id=1
GROUP BY content_id


