-- Orbid müügid (kas kõik sales tabelis olevad kliendid eksisteerivad) — kas on customer_id, mida pole customers tabelis?
SELECT COUNT(*) AS orb_klient
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (SELECT customer_id FROM customers WHERE customer_id IS NOT NULL);
  -- 0 müüki viitab olematule kliendile

  --Kas kõik sales tabelis viidatud tooted eksisteerivad?
  --Orbid müügid kas on mõni product_id, mida ei ole products tabelis?
  select count (*) as orb_toode
  from sales
  where product_id is not null
  and product_id not in (select product_id from products where product_id is not null);
  --0 müüki viitab olematule tootele

  -- Kas on kliente, kelle id ei ole sales tableis (kes ei ole kunagi ostnud)
select count(*) as vaimkliendid
from customers
where customer_id not in (select customer_id from sales where customer_id is not null);
--592 klienti ei ole kunagi ostnud

--Kas on tooteid, mida pole kunagi müüdud
select count(*) as vaimtooted
from products
where product_id not in (select product_id  from sales where product_id is not null);
--12 toodet ei ole kunagi müüdud


--Kas müügihind klapib tootehinnaga (JOIN)
SELECT s.sale_id, s.total_price, p.retail_price AS tootehind, s.quantity,
       s.total_price - (p.retail_price * s.quantity) AS erinevus
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE ABS(s.total_price - (p.retail_price * s.quantity)) > 1
ORDER BY ABS(s.total_price - (p.retail_price * s.quantity)) DESC
LIMIT 20;
-- 20 müügis ei klapi müügihind tootehinnaga

-- Millistel tootel on suurimad hinnaerinevused?
SELECT p.product_name, p.category, p.retail_price AS list_hind,
       AVG(s.total_price / NULLIF(s.quantity, 0)) AS kesk_muugihind,
       p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0)) AS erinevus
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.retail_price
HAVING ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) > 5
ORDER BY ABS(p.retail_price - AVG(s.total_price / NULLIF(s.quantity, 0))) DESC
LIMIT 10;

