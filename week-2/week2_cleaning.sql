--Kas kõik müügis viidatud kliendid eksisteerivad
-- Orbid müügid — kas on customer_id, mida pole customers tabelis?
SELECT COUNT(*) AS orb_klient
FROM sales
WHERE customer_id IS NOT NULL
  AND customer_id NOT IN (SELECT customer_id FROM customers WHERE customer_id IS NOT NULL);
