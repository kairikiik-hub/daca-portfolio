--Tooted, mida pole kunagi müüdud left join
select
p.product_name,
p.category,
p.subcategory,
p.retail_price,
s.sale_id
from products p
left join sales s on p.product_id = s.product_id
where s.sale_id is null; --kui sale_id on null, siis toodet pole kunagi müüdud 
--12 toodet pole kunagi müüdud

--Loen müümata tooteid kokku 
select count(*) as müümata_tooted
from products p
left join sales s on p.product_id = s.product_id
where s.sale_id is null;
--müümata tooteid 12

--Enim müüdud tooted
select
p.product_name,
p.category,
p. subcategory,
count(s.sale_id) as müüdud_kordi,
sum(s.total_price) as kogumüük
from products p
inner join sales s on p.product_id = s.product_id
group by p.product_id, p.product_name, p.category, p.subcategory
order by kogumüük desc
limit 10;

--Analüüsid kategooriate kaupa
select
p.category,
count(distinct p.product_id) as tooteid,
count(s.sale_id) as müüke,
sum(s.total_price) as kogumüük
from products p
left join sales s on p.product_id = s.product_id
group by p.category
order by kogumüük desc;

--ühenda inventuuriga - millised tooted on laos?
select
p.product_name, p.category, i.location, i.quantity_available, i.reorder_point,
case when i.quantity_available <= i.reorder_point
then 'TELLI JUURDE'
else 'OK'
end as staatus
from products p
left join inventory i on p.product_id = i.product_id
order by i.quantity_available asc;
