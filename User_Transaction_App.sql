--- N0.1
SELECT t.member_id, m.created_at AS register_at, MIN(t.created_at) AS transaksi_at
FROM members m INNER JOIN transaksi t
ON m.id= t.member_id
WHERE status_pengisian = 'Berhasil' AND type_transaksi = 'Transaksi'
GROUP BY 1
HAVING MIN(t.created_at) BETWEEN '2023-02-01 00:00:00' AND '2023-03-01 00:00:00'
AND SUM(t.price) >= 50000
ORDER BY MIN(t.created_at) ASC;

--- NO.2

WITH PREV_DATA AS (
SELECT COUNT(DISTINCT member_id) AS PREV
FROM transaksi
WHERE created_at BETWEEN '2023-01-01 00:00:00' AND  '2023-02-01 00:00:00'
AND status_pengisian = 'Berhasil' AND type_transaksi = 'Transaksi')
SELECT CONCAT(ROUND(COUNT(DISTINCT member_id) / (SELECT PREV FROM PREV_DATA) * 100,2), '%')  AS retention
FROM transaksi 
WHERE created_at BETWEEN '2023-02-01 00:00:00' AND '2023-03-01 00:00:00'
AND member_id IN (
SELECT DISTINCT member_id 
FROM transaksi 
WHERE created_at BETWEEN '2023-01-01 00:00:00' AND '2023-02-01 00:00:00'
AND status_pengisian = 'Berhasil' AND type_transaksi = 'Transaksi')
AND status_pengisian = 'Berhasil' AND type_transaksi = 'Transaksi';

--- NO.3
SELECT DATE_FORMAT(t.created_at, '%M') AS bulan, mt.tier_name AS tier, COUNT(DISTINCT mt.member_id) AS total
FROM transaksi t INNER JOIN members_tier mt
ON t.member_id = mt.member_id
WHERE t.created_at BETWEEN '2023-01-01 00:00:00' and  '2023-03-01 00:00:00'
GROUP BY 1,2
ORDER BY 1,2;

--- NO.4
SELECT DATE_FORMAT(created_at, '%Y-%m') AS bulan, COUNT(id) AS total, 
IFNULL(CONCAT(ROUND(100*(COUNT(id) - LAG(COUNT(id), 1, 0)
OVER (ORDER BY DATE_FORMAT(created_at, '%Y-%m'))) / LAG(COUNT(id), 1, 0)
OVER (ORDER BY DATE_FORMAT(created_at, '%Y-%m')),2), '%'), concat(0.00, '%')) AS growth
FROM transaksi
WHERE type_transaksi = 'Transaksi' AND status_pengisian = 'Berhasil'
AND created_at BETWEEN '2022-10-01 00:00:00' and '2023-03-01 00:00:00'
GROUP BY 1;

--- NO.5


