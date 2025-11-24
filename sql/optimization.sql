-- Indexoptimering och EXPLAIN ANALYZE (VG)
-- Kör efter schema.sql och testdata.sql

SET search_path TO public;

-- Query 1: Hitta produkter per varumärke
-- Problemet: Saknar index på brands.name när vi söker med LOWER()

-- Plan före index
EXPLAIN ANALYZE
SELECT p.id, p.name, b.name AS brand_name
FROM products p
JOIN brands b ON b.id = p.brand_id
WHERE LOWER(b.name) = LOWER('NovaTech');

-- Skapa index
CREATE INDEX IF NOT EXISTS idx_brands_name_lower ON brands ((LOWER(name)));

-- Plan efter index
EXPLAIN ANALYZE
SELECT p.id, p.name, b.name AS brand_name
FROM products p
JOIN brands b ON b.id = p.brand_id
WHERE LOWER(b.name) = LOWER('NovaTech');

-- Query 2: Top-spenderande kunder
-- Problemet: JOIN och WHERE på status tar tid utan index

-- Plan före index
EXPLAIN ANALYZE
SELECT c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY c.first_name, c.last_name;

-- Skapa kompositindex
CREATE INDEX IF NOT EXISTS idx_orders_customer_status ON orders (customer_id, status);

-- Plan efter index
EXPLAIN ANALYZE
SELECT c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY c.first_name, c.last_name;
