-- MARET 2022 - FEBRUARI 2023

WITH data AS (
SELECT member_id, MIN(DATE_FORMAT(t.created_at)) AS cohort_month 
FROM transaksi t
WHERE type_transaksi = 'Transaksi'
AND status_pengisian = 'Berhasil'
GROUP BY 1
),
order_element AS (
SELECT member_id, cohort_month, EXTRACT(YEAR FROM cohort_month) AS order_year, EXTRACT(MONTH FROM created_at) AS order_month
FROM data
),
first_order AS (
SELECT member_id, MIN(created_at) AS first_order_date
FROM data
GROUP BY 1
),
first_element AS (
SELECT member_id, first_order_date, EXTRACT(YEAR FROM first_order_date) AS FO_year, EXTRACT(MONTH FROM first_order_date) AS FO_month
FROM first_order
),
diff AS (
SELECT A.member_id, A.order_year - C.FO_year AS year_diff, A.order_month - C.FO_month AS month_diff 
FROM order_element A INNER JOIN first_element C
ON A.member_id = C.member_id
),
cohort_index AS (
SELECT member_id, year_diff * 12 + month_diff + 1 AS cohort_index
FROM diff
),
cohort_data AS (
SELECT DISTINCT(D.member_id), B.FO_month, D.cohort_index
FROM cohort_index D INNER JOIN first_element B 
ON D.member_id = B.member_id
)
SELECT FO_month, 
SUM(CASE WHEN cohort_index = 1 THEN 1 ELSE 0 END) AS month_1,
SUM(CASE WHEN cohort_index = 2 THEN 1 ELSE 0 END) AS month_2,
SUM(CASE WHEN cohort_index = 3 THEN 1 ELSE 0 END) AS month_3,
SUM(CASE WHEN cohort_index = 4 THEN 1 ELSE 0 END) AS month_4,
SUM(CASE WHEN cohort_index = 5 THEN 1 ELSE 0 END) AS month_5,
SUM(CASE WHEN cohort_index = 6 THEN 1 ELSE 0 END) AS month_6,
SUM(CASE WHEN cohort_index = 7 THEN 1 ELSE 0 END) AS month_7,
SUM(CASE WHEN cohort_index = 8 THEN 1 ELSE 0 END) AS month_8,
SUM(CASE WHEN cohort_index = 9 THEN 1 ELSE 0 END) AS month_9,
SUM(CASE WHEN cohort_index = 10 THEN 1 ELSE 0 END) AS month_10,
SUM(CASE WHEN cohort_index = 11 THEN 1 ELSE 0 END) AS month_11,
SUM(CASE WHEN cohort_index = 12 THEN 1 ELSE 0 END) AS month_12
FROM cohort_data
GROUP BY 1;