-- Electronics Shop - Indexoptimering och EXPLAIN ANALYZE (Del 2, VG)
-- Kör i electronics_db efter schema.sql och testdata.sql

SET search_path TO public;

/* ------------------------------------------------------------
   1) Identifierad query: Hitta produkter per varumärke (queries.sql #5)
   Ursprunglig plan saknade index på brands(name).
------------------------------------------------------------- */

-- Visa ursprunglig plan
EXPLAIN ANALYZE
SELECT p.id,
       p.name,
       b.name AS brand_name
FROM products p
JOIN brands b ON b.id = p.brand_id
WHERE LOWER(b.name) = LOWER('NovaTech');

-- Skapa index för att snabba upp sökningar på namn
CREATE INDEX IF NOT EXISTS idx_brands_name_lower
ON brands ((LOWER(name)));

-- Plan efter index
EXPLAIN ANALYZE
SELECT p.id,
       p.name,
       b.name AS brand_name
FROM products p
JOIN brands b ON b.id = p.brand_id
WHERE LOWER(b.name) = LOWER('NovaTech');

/* ------------------------------------------------------------
   2) Identifierad query: Top-spenderande kunder (queries.sql #9)
   Aggregationen görs ofta -> index på orders(customer_id, status).
------------------------------------------------------------- */

-- Ursprunglig plan
EXPLAIN ANALYZE
SELECT c.first_name,
       c.last_name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY c.first_name, c.last_name;

-- Skapa kompositindex för att täcka JOIN + statusfilter
CREATE INDEX IF NOT EXISTS idx_orders_customer_status
ON orders (customer_id, status);

-- Plan efter index
EXPLAIN ANALYZE
SELECT c.first_name,
       c.last_name,
       SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY c.first_name, c.last_name;

