WITH cte AS (
  SELECT C.customer_id,
    customer_name,
    city,
    state,
    order_id,
    payment,
    order_date,
    delivery_date
  FROM `deepp-jan24-laksmisetiawati.deepp_dataset.customers` AS C
  LEFT JOIN `deepp-jan24-laksmisetiawati.deepp_dataset.orders` AS O
    ON O.customer_id = C.customer_id
  ORDER BY customer_id ASC
)
SELECT COUNT(customer_name) AS total_customer 
FROM cte
WHERE order_id IS NULL