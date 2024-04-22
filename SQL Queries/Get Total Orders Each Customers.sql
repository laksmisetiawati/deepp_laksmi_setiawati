SELECT C.customer_id,
  customer_name,
  COUNT(order_id) AS total_orders
FROM `deepp-jan24-laksmisetiawati.deepp_dataset.customers` AS C
LEFT JOIN `deepp-jan24-laksmisetiawati.deepp_dataset.orders` AS O
  ON O.customer_id = C.customer_id
GROUP BY C.customer_id, customer_name
ORDER BY customer_id ASC