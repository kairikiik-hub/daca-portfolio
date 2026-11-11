-- Mitu rida on tabelis sales
select count (*) from sales;
--15234

--Millised veerud on tabelis sales
select * from sales;

--Millised kauplused on esindatud
select distinct channel
from sales;

--filtreeritud asukoha järgi
select * from sales
where store_location ='Tallinn';

--Milised suurimad tehingud
select total_price
from sales
order by total_price desc
limit 5;

--Milised väiksemad tehingud
select total_price
from sales
order by total_price
limit 5;

--puuduvad väärtused
-- Mitu klienti, kus eesnimi on puudu?
SELECT COUNT(*) - COUNT(customer_id) AS puuduv_klient
FROM sales;
--1487

--kaupluste asukohad
select distinct store_location
from sales;
