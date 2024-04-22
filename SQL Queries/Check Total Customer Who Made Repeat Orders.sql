WITH cte1 AS (
  SELECT C.customer_id,
    COUNT(order_id) AS total_orders
  FROM `deepp-jan24-laksmisetiawati.deepp_dataset.customers` AS C
  LEFT JOIN `deepp-jan24-laksmisetiawati.deepp_dataset.orders` AS O
    ON O.customer_id = C.customer_id
  GROUP BY C.customer_id
  ORDER BY customer_id ASC
), cte2 AS (
  SELECT 
    COUNT(customer_id) AS total_customer,
    total_orders
  FROM cte1
  GROUP BY total_orders
)
SELECT * FROM cte2
ORDER BY total_orders