WITH cte0 AS(
  SELECT 
    "test" AS test,
    COUNT(DISTINCT O.order_id) AS total_all_order,
    SUM(total_price) AS total_all_sale_price
  FROM `deepp-jan24-laksmisetiawati.deepp_dataset.orders` 
    AS O
  JOIN `deepp-jan24-laksmisetiawati.deepp_dataset.sales` 
    AS S
    ON O.order_id=S.order_id
), cte1 AS(
  /** Get monthly sale price */
  SELECT 
    "test" AS test,
    EXTRACT(MONTH FROM order_date) AS month,
    COUNT(DISTINCT S.order_id) AS total_order,
    SUM(total_price) AS sale_price
  FROM `deepp-jan24-laksmisetiawati.deepp_dataset.orders` 
    AS O
  JOIN `deepp-jan24-laksmisetiawati.deepp_dataset.sales` 
    AS S
    ON O.order_id=S.order_id
  GROUP BY
    month
), cte2 AS (
  /** Get previous monthly sale price */
  SELECT 
    month,
    total_order,
    LAG(total_order) 
      OVER(ORDER BY month) 
      AS prev_total_order,
    total_all_order,
    ROUND(total_order/total_all_order*100, 2)
      AS total_order_percent,
    sale_price,
    LAG(sale_price) 
      OVER(ORDER BY month) 
      AS prev_sale_price,
    total_all_sale_price,
    ROUND(sale_price/total_all_sale_price*100, 2)
      AS sale_price_percent
  FROM cte1
  LEFT JOIN cte0
    ON cte1.test=cte0.test
), cte3 AS (
  SELECT
    *,
    LAG(total_order_percent) 
      OVER(ORDER BY month) 
      AS prev_total_order_percent,
    LAG(sale_price_percent) 
      OVER(ORDER BY month) 
      AS prev_sale_price_percent,
  FROM cte2
), cte4 AS (
  SELECT
    *,
    CASE 
      WHEN total_order > prev_total_order THEN
        "Up"
      ELSE
        "Down"
    END AS total_order_growth,
    CASE 
      WHEN total_order_percent > prev_total_order_percent THEN
        ROUND(total_order_percent - prev_total_order_percent, 2)
      ELSE
        ROUND(prev_total_order_percent - total_order_percent, 2)
    END AS total_order_growth_percent,
    CASE 
      WHEN sale_price > prev_sale_price THEN
          "Up"
      ELSE
          "Down"
    END AS sale_price_growth,
    CASE 
      WHEN sale_price_percent > prev_sale_price_percent THEN
        ROUND(sale_price_percent - prev_sale_price_percent, 2)
      ELSE
        ROUND(prev_sale_price_percent - sale_price_percent, 2)
    END AS sale_price_growth_percent
  FROM cte3
)
SELECT 
  month,
  total_order,
  total_order_growth,
  total_order_percent,
  total_order_growth_percent,
  total_all_order,
  sale_price,
  sale_price_growth,
  sale_price_percent,
  sale_price_growth_percent,
  total_all_sale_price    
FROM cte4
ORDER BY
  month ASC

-- The seasons are defined as 
-- spring (March, April, May)
-- summer (June, July, August)
-- autumn (September, October, November)
-- winter (December, January, February).