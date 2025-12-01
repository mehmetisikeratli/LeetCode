
SELECT *
    , ROUND( (curr_year_spend-prev_year_spend)/prev_year_spend * 100, 2) AS yoy_rate
FROM (
SELECT YEAR(transaction_date) AS year
    , product_id
    , SUM(spend) AS curr_year_spend
    , LAG(SUM(spend)) OVER(PARTITION BY product_id ORDER BY product_id, YEAR(transaction_date) ASC) AS prev_year_spend
FROM user_transactions
-- WHERE product_id=1001
GROUP BY 1,2
ORDER BY 2,1
) a
ORDER BY 2,1
