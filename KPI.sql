--- TRANSACTION

SELECT id, member_id, price, created_at, type_transaksi, 
produk_description
FROM transaksi
WHERE created_at BETWEEN '2023-06-01 00:00:00' 
AND '2023-06-08 00:00:00'
AND status_pengisian = 'Berhasil'
AND type_transaksi IN ('Transaksi', 'Topup')
ORDER BY 4;

SELECT id, member_id, price, created_at, updated_at, type_transaksi, produk_description,
CASE WHEN member_id IN (
14671, 14594, 14619, 14606, 14638, 
15343, 14623, 14627, 14756, 15258, 
14621, 14566, 14583, 14434, 14601, 14673, 14590) THEN 'INTERN'
ELSE 'NOT INTERN' END AS ket_status
FROM transaksi
WHERE created_at BETWEEN '2023-04-01 00:00:00' AND '2023-05-01 00:00:00'
AND status_pengisian = 'Berhasil'
AND type_transaksi IN ('Transaksi', 'Topup');

--- REGISTER
SELECT id AS TOTAL_REGISTER, created_at
FROM members
WHERE created_at < '2023-06-01 00:00:00';

-- ALL REGISTER
SELECT id, created_at AS tgl_register
FROM members
WHERE created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
ORDER BY id ASC;

-- REGISTER ANAK MAGANG
SELECT id AS member_id, created_at AS register_at
FROM members
WHERE created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
AND id_atas IN (
SELECT id FROM members WHERE kode_referral IN (
'BBY7OJ','BBCI82','BBI56T','BB7WTX','BBZRG8','BBY7ZK','BBGN68','BBPKYH',
    'BBGBAE','BBOXT0','BBSHC5','BB0F5K','BB9D80','BBS4UW','BB8FQ1','BBIKL2',
    'BBNI30','BBPARU','BBB0HZ','BB2QIY','BBHDL2','BBWED5','BBQP41','BBQUJM',
    'BB4378','BB5TNP','BB05RJ','BB1CN8','BBYF8R','BB4NQS','BBRB9G','BBILD0',
    'BBJNF0','BBTC7D','BBEWAY','BBBOQS','BB3Z8T','BBP098','BB1FVM','BB4H0G',
    'BBDN6B','BBFQ7Y','BBG9EC','BBSDRJ','BBE36U','BBW4IY','BBP4VD','BBFUHA',
    'BBXSVL','BBTAOY','BB94TC','BBYJE9','BBT2N3','BBYEPG','BBBLET','BBWJ1F',
    'BBEPGJ','BBYT05','BB0NK5'))
ORDER BY 1 ASC;

-- REGISTER YANG PAKE KODE REFERRAL SELAIN ANAK MAGANG
SELECT id AS member_id, created_at AS register_at
FROM members
WHERE created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
AND id_atas IN (
SELECT id FROM members WHERE kode_referral NOT IN (
'BBY7OJ','BBCI82','BBI56T','BB7WTX','BBZRG8','BBY7ZK','BBGN68','BBPKYH',
    'BBGBAE','BBOXT0','BBSHC5','BB0F5K','BB9D80','BBS4UW','BB8FQ1','BBIKL2',
    'BBNI30','BBPARU','BBB0HZ','BB2QIY','BBHDL2','BBWED5','BBQP41','BBQUJM',
    'BB4378','BB5TNP','BB05RJ','BB1CN8','BBYF8R','BB4NQS','BBRB9G','BBILD0',
    'BBJNF0','BBTC7D','BBEWAY','BBBOQS','BB3Z8T','BBP098','BB1FVM','BB4H0G',
    'BBDN6B','BBFQ7Y','BBG9EC','BBSDRJ','BBE36U','BBW4IY','BBP4VD','BBFUHA',
    'BBXSVL','BBTAOY','BB94TC','BBYJE9','BBT2N3','BBYEPG','BBBLET','BBWJ1F',
    'BBEPGJ','BBYT05','BB0NK5'))
ORDER BY 1 ASC;

-- REGISTER UMUM
SELECT id, created_at AS tgl_register
FROM members
WHERE created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
AND id_atas IS NULL
ORDER BY id ASC;

SELECT id, created_at AS tgl_register, 
CASE WHEN id_atas IN (
SELECT id FROM members WHERE kode_referral IN (
'BBY7OJ','BBCI82','BBI56T','BB7WTX','BBZRG8','BBY7ZK','BBGN68','BBPKYH',
    'BBGBAE','BBOXT0','BBSHC5','BB0F5K','BB9D80','BBS4UW','BB8FQ1','BBIKL2',
    'BBNI30','BBPARU','BBB0HZ','BB2QIY','BBHDL2','BBWED5','BBQP41','BBQUJM',
    'BB4378','BB5TNP','BB05RJ','BB1CN8','BBYF8R','BB4NQS','BBRB9G','BBILD0',
    'BBJNF0','BBTC7D','BBEWAY','BBBOQS','BB3Z8T','BBP098','BB1FVM','BB4H0G',
    'BBDN6B','BBFQ7Y','BBG9EC','BBSDRJ','BBE36U','BBW4IY','BBP4VD','BBFUHA',
    'BBXSVL','BBTAOY','BB94TC','BBYJE9','BBT2N3','BBYEPG','BBBLET','BBWJ1F',
    'BBEPGJ','BBYT05','BB0NK5')) THEN 'DOWNLINE' 
    ELSE 'NON DOWNLINE' END AS ket
FROM members
WHERE created_at BETWEEN '2023-04-01 00:00:00' AND '2023-05-01 00:00:00'
ORDER BY id ASC;

--- NEW USER

SELECT m.id, m.created_at AS tgl_register, 
MIN(t.created_at) AS tgl_transaksi
FROM members m LEFT JOIN transaksi t
ON m.id = t.member_id
WHERE status_pengisian = 'Berhasil' 
AND type_transaksi = 'Transaksi'
GROUP BY 1
HAVING MIN(t.created_at) BETWEEN '2023-06-01 00:00:00' 
AND '2023-06-08 00:00:00'
ORDER BY 3 ASC;

--- PREMIUM
SELECT id, created_at, status_member,
CASE WHEN id IN (
14671, 14594, 14619, 14606, 14638, 
15343, 14623, 14627, 14756, 15258, 
14621, 14566, 14583, 14434, 14601, 14673, 14590) THEN 'INTERN'
ELSE 'NOT INTERN' END AS ket_status
FROM members
WHERE created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
AND status_member = 'premium';

SELECT t.id, t.member_id, t.price, t.created_at, t.type_transaksi, t.produk_description, m.status_member
FROM transaksi t LEFT JOIN members m ON t.member_id = m.id
WHERE t.created_at BETWEEN '2023-06-01 00:00:00' AND '2023-06-08 00:00:00'
AND status_pengisian = 'Berhasil'
AND type_transaksi IN ('Transaksi', 'Topup')
ORDER BY 4;

select id, username, created_at, status_member
from members
where id = 13737; 