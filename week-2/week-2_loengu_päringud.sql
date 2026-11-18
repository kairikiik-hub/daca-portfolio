--Loeng
--Loon müügiandmetest test tabeli
--loob selle uue taebli selle select * from põhjal
create table sales_test as select*from sales;
--success
--loon ridade arvud
select count(*) from sales;
--15234
select count(*) from sales_test;
--15234

--olemasoleva tabeli kustutamine
drop table sales_test;

--andmete sisestamine olemasolevasse tabelisse
insert into sales_test
select*from sales;

select*from sales_test 
where id > 15230 
limit 10;

--testi enne kustutamist valikuga, et kas valisid õiged read
delete
--select *
 from sales_test
where channel ='online'

--test tabeli kustutamine ja uue loomine
drop table if exists sales_test;
create table sales_test as select*from sales;

--loo test tabelist customers
drop table if exists customers_tests;

--loo table
create table customers_test as
select*from customers;

-- samm 1: leiame duplikaadid
select invoice_id, count(*) as koopiate_arv
from sales_test
group by invoice_id
--read, kus suurem kui 1
having count(*) >1
order by invoice_id desc;

select*from sales_test
where invoice_id ='INV-202404-00114';

--samm 2: Mitu rida on duplikaadid (sisaldab alampäringut)
select count(*) as duplikaat_read
from sales_test
--id on see mis on erinev, aga tegelt on sama oma ()
where id not in (
--iga invoice minimaalne id
select min(id) 
from sales_test
group by invoice_id
)
--5116 duplikaati (muidu ridu 15234)

select 15234-5116;
--10118 unikaalset arvet

--samm 3: Kustuta duplikaat read
delete 
--select*
from sales_test
--id on see mis on erinev, aga tegelt on sama oma ()
where id not in (
--iga invoice minimaalne id
select min(id) 
from sales_test
group by invoice_id
)

select count(*) from sales_test;
--10118 (duplikaadid eemaldatud)

--COALESCE KÄSK  - ASENDAB ESIMESE MITTE NULL VÄÄRTUSE
select*from sales_test
where customer_id is null;
--998 rida

--muutsin 21 ja 34 id customer id 0
update sales_test
set customer_id =0
where customer_id is null and id in (21,34);

update sales_test
set customer_id =0
where customer_id is null and id in (21,34);

--muutmine, coalesce võtab esimese tühja väärtuse
update sales_test
set customer_id = coalesce (customer_id, 0)
where id in (21,34);













