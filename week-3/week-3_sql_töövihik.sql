--teen tabelitest raw-koopiad
create table sales_raw_koopia as select*from sales;
create table products_raw_koopia as select*from products;
create table customers_raw_koopia as select*from customers;
create table inventory_raw_koopia as select*from inventory;

--Kustutan duplikaadid sales tabelist
delete 
from sales
where id not in(
  select min(id)
  from sales
  group by sale_id
);
select * from sales;
--10118 rida

--Paranda tuleviku kuupäevad
update sales
set sale_date = current_date
where sale_date > current_date;

-- Ühtlusta klientide linnanimed (muidu group byb city näitab 50+ varianti 12 asemel)
update customers
set city = initcap (trim(city))
where city is not null;

--Kontrolli tulemusi
select count(*) as sales_ridu from sales;
--10118
select count (distinct city) as linnu from customers;
--12

--Inner join: kliendid koos nende müükidega
select
c.first_name,
c.last_name,
c.city,
s.sale_id,
s.sale_date,
s.total_price
from sales s
inner join customers c on s.customer_id = c.customer_id
order by s.total_price desc
--order by c.city desc
limit 20;
--ilma limit 9130 rida, Madis Roots suurim tellimus

-- ühenda tabelid sales ja products
select
p.product_name as Toode,
s.total_price as,
p.category,
s.quantity as kogus,
s.unit_price as ühikuhind
from sales s inner join products p on s.product_id = p.product_id
order by s.quantity desc
limit 15;

select * from products;
select * from sales;
select * from customers;

--oma päring - millistest linnadest tulevad tellimused
select
s.sale_id,
c.city
from sales s inner join customers c on s.customer_id = c.customer_id
order by c.city desc
limit 20;

--Left join
select 
c.first_name,
c.last_name,
c.city,
s.sale_id,
s.total_price
from customers c left join sales s on c.customer_id = s.customer_id
order by s.total_price desc nulls last;

-- read, mis on ainult vasakus tabelis (kliendid, kes pole kunagi ostnud)
select
c.first_name,
c.last_name,
c.email,
c.city,
c.registration_date
from customers c left join sales s on c.customer_id = s.customer_id
where s.sale_id is null;

-- Kadunud kliendid: left join + where is null
select
c.customer_id,
c.first_name || ' ' || c.last_name as nimi,
c.email,
c.city,
c.registration_date
from customers c left join sales s on c.customer_id = s.customer_id
where s.sale_id is null
order by c.registration_date desc;
--599 klienti, kes pole ostnud (kadunud?)

--võrdluseks: inner_join (ainult aktiivsed kliendid, kes on ostnud )
select count (distinct c.customer_id) as aktiivsed_kliendid
from sales s inner join customers c on s.customer_id = c.customer_id;
--aktiivseid kliente 2551

--Tooted, mida ei ole müüdus
select
p.product_name,
p.category,
p.retail_price
from products p left join sales s on p.product_id = s.product_id
where s.sale_id is null
order by retail_price desc;
--12 müümata toodet

select * from products;

--kadunud kliente linnade kaupa
select
c.city,
count (c.customer_id) as kadunud_klientide_arv
from customers c left join sales s on c.customer_id = s.customer_id
where s.sale_id is null
group by c.city
order by kadunud_klientide_arv desc;
--kõige rohkem kadunud kliente Tallinnast

-- left join (kõik read vasakult)
select c.first_name, s.sale_id
from customers c left join sales s on c.customer_id = s.customer_id;
--9729

--right join (kõik read paremalt)
select c.first_name, s.sale_id
from sales s right join customers c on s.customer_id = c.customer_id;
--sama tulemus 9729

--Mitme tabeli ühendamine
select
c.first_name || ' ' || c.last_name as klient,
c.city,
s.sale_date,
s.total_price,
p.product_name,
p.category,
s.quantity,
s.unit_price
from sales s inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id
order by s.total_price desc
limit 20;

--3 tabelit join; kes ostis mida?
select
c.first_name || ' ' || c.last_name as klient,
c.city as linn,
s.sale_date as müügi_kuupäev,
p.product_name as toode,
p.category as kategooria,
s.quantity as kogus,
s.unit_price as ühikuhind,
s.total_price as rea_summa
from sales s
inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id
order by rea_summa desc
limit 20;

--millised kategooriad müüvad kõige rohkem
select
c.city,
p.category,
sum(s.total_price) as kogumüük,
c.city
from sales s
inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id
group by c.city, p.category
order by kogumüük desc;
--kõige kasumlikkum Tallinn+jalanõud

--Millised kategooriad on populaarsed eri linnades
select
p.category,
c.city,
count(s.sale_id) as ostude_arv
from sales s
inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id
group by c.city, p.category
order by c.city asc, ostude_arv desc;

--TOP 20 klienti 
select
c.first_name || ' ' || c.last_name as klient,
c.city as linn,
p.category as kategooria,
sum(s.total_price) as kogumüük
from sales s
inner join customers c on s.customer_id = c.customer_id
inner join products p on s.product_id = p.product_id
group by c.customer_id, p.category, c.first_name, c.last_name, c.city
order by kogumüük desc
limit 20;

-- Kadunud kliente linnade kaupa
select
c.city,
count (c.customer_id) as kadunud_klientide_arv
from customers c left join sales s on c.customer_id = s.customer_id
where s.sale_id is null
group by c.city
order by kadunud_klientide_arv desc;

--Müümata tooted kategooriate kaupa
select
p.product_name,
p.category,
p.retail_price
from products p left join sales s on p.product_id = s.product_id
where s.sale_id is null
order by retail_price desc;

--tooted, mis on laos, aga ei ole kordagi müüdud
SELECT
p.product_name,
p.category,
p.retail_price,
i.quantity_available,
(p.retail_price * i.quantity_available) AS kinni_olev_raha
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE s.sale_id IS NULL     AND i.quantity_available > 0
ORDER BY kinni_olev_raha DESC; 
--Success. No rows returned (ei ole ühtegi toodet, mis laos seisaks)

