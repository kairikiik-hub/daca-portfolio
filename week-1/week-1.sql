-- Mitu rida on tabelis sales
select count (*) from sales;
--15234

--Kui palju on unikaalseid tehinguid
select count (distinct sale_id)
from sales;
--10118

--Millised veerud on tabelis sales
select * from sales;

--Millised kauplused on esindatud
select distinct channel
from sales;

-- Unikaalsed kliendid
select count (distinct customer_id)
from sales;
--2558

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

--Palju on negatiivse väärtusega tehinguid
select count (total_price ) as negatiivsed_tehingud
from sales
where total_price < 0;
--305

--puuduvad väärtused
-- Mitu klienti, kus eesnimi on puudu?
SELECT COUNT(*) - COUNT(customer_id) AS puuduv_klient
FROM sales;
--1487

--kaupluste asukohad
select distinct store_location
from sales;
--Tallinn, Pärnu, Tartu, null

--palju tehinguid Tallinnas
select count (store_location)
from sales
where store_location = 'Tallinn';
--5704

--palju tehinguid Tartus
select count (store_location)
from sales
where store_location = 'Tartu';
--2708

--palju tehinguid Pärnus
select count (store_location)
from sales
where store_location = 'Pärnu';
--1618

--palju ilma asukohata tehinguid
select count(*) - count (store_location)
from sales;
--5204
