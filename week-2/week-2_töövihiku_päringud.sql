--Leia duplikaatsed sale_id väärtused
select
sale_id,
count (*) as koopiate_arv
from sales
group by sale_id
having count (*) > 1
order by koopiate_arv desc;

--Anna igale reale number grupi sees
select
sale_id,
customer_id,
total_price,
sale_date,
row_number () over (partition by sale_id order by sale_date) as rn
from sales;

--Leia kõik duplikaatsed sale_id väärtused sales tabelis
select
sale_id,
count (*) as koopiate_arv
from sales
group by sale_id
having count (*) > 1
order by koopiate_arv desc
limit 10;

--Duplikaate mõju müüginumbritele
select
count (*) as ridu_kokku,
count(distinct sale_id) as unikaalseid,
count(*) - count(distinct sale_id) as duplikaate,
sum(total_price) as summa_duplikaatidega,
(select sum(total_price) from(
  select distinct on (sale_id) total_price
  from sales
  order by sale_id, id --iga müügiga väikseima id-ga rida = originaal
) unikaalsed) as summa_ilma_duplikaatideta
from sales;

-- Kliendid, kelle email kordub
select * from
(select
  customer_id,
  first_name,
  last_name,
  email,
  row_number() over (partition by email order by customer_id) as rn
from customers
where email is not null
) numbered
order by email;

--Kliendid, korduvate emailidega
select email, count(*) as kordi
from customers
group by email
having count(*) > 1;

--Minu duplikaadid tabelist customers
select
email,
count(*) as Koopiate_arv
from customers
group by email
having count(*) >1
order by koopiate_arv desc;

--tellimused, kus klient on teadmata
select sale_id, customer_id, total_price
from sales
where customer_id is null;

--leia kliendid, kellel email on olemas
select customer_id, first_name, email
from customers
where email is not null;

--asenda puuduv kliendi nimi vaikeväärtusega
select
customer_id,
coalesce (first_name, 'Tundmatu') as Eesnimi,
coalesce (email, 'puudub@urbanstyle.ee') as email
from customers;

--mitu asendusväärtust (valib esimese mitte-Null väärtuse)
select coalesce(null, null, 'kolmas valik');
--kolmas valik

--nullif (a, b): kui a=b, tagastab null, muidu tagastab a
select nullif (100, 100);
--NULL
select nullif(100, 200);
--100

--Muuda 0 hinnaga tooted nulliks. Hind pole tegelikult null vaid puudu
select 
product_id,
product_name,
nullif(retail_price, 0) as puhas_hind
from products;

-- NULL-ide ülevaade customers tabelis
SELECT
    COUNT(*) AS kliente_kokku,
    COUNT(first_name) AS eesnimi_olemas,
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub,
    COUNT(email) AS email_olemas,
    COUNT(*) - COUNT(email) AS email_puudub,
    COUNT(phone) AS telefon_olemas,
    COUNT(*) - COUNT(phone) AS telefon_puudub
FROM customers;

--asenda puuduv kliendi nimi vaikeväärtusega
select
customer_id,
coalesce (first_name, 'Tundmatu_klient') as Eesnimi,
coalesce (last_name, 'Tundmatu_klient') as Perekonnanimi,
coalesce (email, 'puudub@urbanstyle.ee') as email,
coalesce (phone, 'puudub') as Telefon
from customers;

select * from customers

-- Võrdlus: SUM kõigist vs SUM mitte-NULL väärtustest
select
count (*) as ridu,
count (total_price) as summa_olemas,
count(*) - count(total_price) as summa_puudub,
sum(total_price) as kogusumma,
avg(total_price) as keskmine
from sales;

-- CAST süntaks (standardne SQL)
SELECT CAST('125.50' AS NUMERIC);  -- Tekst -> number
SELECT CAST('2024-01-15' AS DATE); -- Tekst -> kuupäev

-- :: süntaks (PostgreSQL-i kiirviis)
SELECT '125.50'::NUMERIC;          -- Sama tulemus
SELECT '2024-01-15'::DATE;        -- Sama tulemus

-- Kuupäev erinevates formaatides
SELECT
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_formaat,
    TO_CHAR(sale_date, 'YYYY-MM-DD') AS iso_formaat,
    TO_CHAR(sale_date, 'DD. Month YYYY') AS pikk_formaat
FROM sales
LIMIT 5;

-- Tekst -> kuupäev (pead ütlema, millises formaadis tekst on)
SELECT TO_DATE('15/03/2024', 'DD/MM/YYYY');  -- Tulemus: 2024-03-15
SELECT TO_DATE('2024-01-15', 'YYYY-MM-DD');  -- Tulemus: 2024-01-15

--TRIM() eemaldab tühikud teksti algusest ja lõpust:
SELECT TRIM('  Tallinn  ');  -- Tulemus: 'Tallinn'
SELECT TRIM('  ');           -- Tulemus: '' (tühi string)

--UPPER() ja LOWER() muudavad teksti suur- või väiketähtedeks:
SELECT UPPER('tallinn');   -- Tulemus: 'TALLINN'
SELECT LOWER('TALLINN');   -- Tulemus: 'tallinn'

-- Leia kõik unikaalsed linnade kirjaviisid
SELECT DISTINCT city
FROM customers
ORDER BY city;


-- Ühtlusta: eemalda tühikud, muuda algustäht suureks
SELECT DISTINCT
    city AS originaal,
    TRIM(city) AS trimitud,
    UPPER(TRIM(city)) AS suurtahtedega,
    INITCAP(TRIM(city)) AS esitaht_suur
FROM customers
WHERE city IS NOT NULL
ORDER BY city;

-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

-- Linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY city;

--Andmete puhastamine
select * from customers

--Grupeeri puhastatud linna veeru järgi (mitte algse city järgi)"
--"Näita iga puhastatud linna kohta: kliente kokku, mitu erinevat algset kirjaviisi"
SELECT 
    INITCAP(TRIM(city)) AS puhastatud_city,
    COUNT(*) AS kliente,
    COUNT(DISTINCT city) AS erinevaid_kirjaviise
FROM customers
GROUP BY puhastatud_city
ORDER BY kliente DESC;

select * from products
--Kontrolli hinnaveeru tüüpi ja väärtusi
select
product_id,
product_name,
retail_price,
case
when retail_price is null then 'null'
when retail_price = 0 then 'null (0=puudub?)'
when retail_price < 0 then 'negatiivne!'
else 'ok'
end as hinna_staatus
from products
where retail_price is null or retail_price <= 0
order by retail_price;

--Duplikaatide ülevaade kõigis tabelites
select 'sales' as tabel,
count (*) as ridu_kokku,
count (distinct sale_id) as unikaalseid,
count (*) - count(distinct sale_id) as duplikaate
from sales
union all
select 'customers',
count (*),
count(distinct email),
-- count (distinct ...) jätab Null-id vahele, seega loetakse emailita kliente
-- duplikaadiks. Lahutame need maha: õige arv 130, mitte 510.
count(*) - count(distinct email) - count(*) filter (where email is null)
from customers
union all
select 'products',
count(*),
count(distinct product_name),
-- koopiatel on uus product_id, aga sama nimi: loe nime järgi
count(*) - count(distinct product_name)
from products;
-- 5116 duplikaati sales tabelis, 130 customer ja 12 products

--Null väärtused
select 'sales' as tabel,
count (*) as ridu_kokku,
count (distinct sale_id) as unikaalseid,
count (*) - count(sale_id) as nulle
from sales
union all
select 'customers',
count (*),
count(distinct email),
-- count (distinct ...) jätab Null-id vahele, seega loetakse emailita kliente
-- duplikaadiks. Lahutame need maha: õige arv 130, mitte 510.
count(*) - count(distinct email) - count(*) filter (where email is null)
from customers
union all
select 'products',
count(*),
count(distinct product_name),
-- koopiatel on uus product_id, aga sama nimi: loe nime järgi
count(*) - count(distinct product_name)
from products;

--Nullid
SELECT 
    'sales' AS tabel,
    COUNT(*) AS ridu_kokku,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS puudu_1,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS puudu_2,
    COUNT(*) FILTER (WHERE amount IS NULL) AS puudu_3
FROM sales

UNION ALL

SELECT 
    'customers',
    COUNT(*),
    COUNT(*) FILTER (WHERE email IS NULL),
    COUNT(*) FILTER (WHERE city IS NULL),
    COUNT(*) FILTER (WHERE first_name IS NULL)
FROM customers

UNION ALL

SELECT 
    'products',
    COUNT(*),
    COUNT(*) FILTER (WHERE product_name IS NULL),
    COUNT(*) FILTER (WHERE price IS NULL),
    NULL -- kui kolmandat olulist veergu pole
FROM products;






