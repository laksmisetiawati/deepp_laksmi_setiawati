WITH cte1 AS (
  SELECT 
    customer_id,
    customer_name,
    gender,
    age,
    2022 - age AS birth_year, /* asumsikan analyst dilakukan di tahun 2022*/
    state,
    country
  FROM `deepp-jan24-laksmisetiawati.deepp_dataset.customers`
)
SELECT
  customer_id,
  customer_name,
  gender,
  age,
  birth_year,
  CASE
    WHEN birth_year BETWEEN 1934 AND 1964
      THEN 'Boomer'
    WHEN birth_year BETWEEN 1965 AND 1980
      THEN 'Gen-X'
    WHEN birth_year BETWEEN 1981 AND 1996
      THEN 'Millennial'
    WHEN birth_year BETWEEN 1997 AND 2012
      THEN 'Gen-Z'
    WHEN birth_year BETWEEN 2013 AND 2025
      THEN 'Gen-Alpha'
    ELSE 'Newest Gen'
  END AS generation,
  state,
  country
FROM cte1
ORDER BY 
  customer_id ASC