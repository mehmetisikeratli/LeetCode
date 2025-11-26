
-- Link: https://leetcode.com/problems/customers-with-maximum-number-of-transactions-on-consecutive-days/

WITH cte AS (
    SELECT *
        , DATE_SUB(transaction_date, INTERVAL rn DAY) AS differences
    FROM (
    SELECT customer_id
        , transaction_date 
        , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY transaction_date) AS rn
    FROM Transactions 
    ) a
) 
, ranking AS (
SELECT customer_id
    , differences
    , COUNT(*) AS cnt
    , RANK() OVER(ORDER BY COUNT(*) DESC) AS rnk
FROM cte
GROUP BY 1,2
)
SELECT customer_id
FROM ranking
WHERE rnk=1
ORDER BY customer_id
