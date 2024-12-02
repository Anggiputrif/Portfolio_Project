-- TAXI TRIPS DATA EXPLORATION

-- BERDASARKAN WAKTU PERJALANAN
-- JAM SIBUK
SELECT EXTRACT(HOUR FROM trip_start_timestamp) AS hour,
COUNT(unique_key) AS trip_count 
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips` 
GROUP BY hour
ORDER BY trip_count DESC;

-- DURASI PERJALANAN RATA-RATA PER JAM
SELECT EXTRACT(HOUR FROM trip_start_timestamp) AS hour,
AVG(trip_seconds) / 60 AS avg_trip_duration_minutes
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY hour
ORDER BY hour;

-- BERDASARKAN LOKASI DAN POLA PERJALANAN
-- JUMLAH PENJEMPUTAN BERDASARKAN AREA
SELECT pickup_community_area, COUNT(unique_key) AS trip_count 
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY pickup_community_area
ORDER BY trip_count DESC
LIMIT 10;

-- AREA DENGAN PERJALANAN TERJAUH
SELECT pickup_community_area, dropoff_community_area, MAX(trip_miles) AS max_distance
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY pickup_community_area, dropoff_community_area
ORDER BY max_distance DESC
LIMIT 10;

-- BERDASARKAN KEUANGAN
-- TOTAL PENDAPATAN PER PERUSAHAAN
SELECT company, SUM(trip_total) AS total_revenue
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY company
ORDER BY total_revenue DESC;

-- RATA-RATA TIPS PER PERUSAHAAN
SELECT company, AVG(tips) AS avg_tips
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE tips > 0
GROUP BY company
ORDER BY avg_tips DESC;

-- METODE PEMBAYARAN
SELECT payment_type, COUNT(unique_key) AS trip_count,
ROUND(COUNT(unique_key) * 100.0 / (SELECT COUNT(unique_key) FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`), 2) AS percentage
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY payment_type
ORDER BY trip_count DESC;
