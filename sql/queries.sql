
-- Electronics Shop - Grundläggande och analytiska queries
-- Kör efter schema.sql och testdata.sql i databasen electronics_db

SET search_path TO public;

-- 1. Grundläggande: Hämta alla produkter sorterade efter namn
SELECT id,
       name,
       price,
       category
FROM products
ORDER BY name;

-- 2. Grundläggande: Hämta alla produkter som kostar mer än 5000 kr
SELECT id,
       name,
       price,
       category
FROM products
WHERE price > 5000
ORDER BY price DESC;

-- 3. Grundläggande: Hämta alla beställningar från år 2024
SELECT id,
       customer_id,
       order_date,
       status,
       total_amount
FROM orders
WHERE order_date BETWEEN DATE '2024-01-01' AND DATE '2024-12-31'
ORDER BY order_date;

-- 4. Grundläggande: Hämta alla beställningar med status pending
SELECT id,
       customer_id,
       order_date,
       total_amount,
       status
FROM orders
WHERE status = 'pending'
ORDER BY order_date DESC;

-- 5. JOIN: Visa alla produkter tillsammans med tillverkarens namn
SELECT p.id,
       p.name AS product_name,
       p.category,
       b.name AS brand_name,
       b.country
FROM products p
JOIN brands b ON b.id = p.brand_id
ORDER BY brand_name, product_name;

-- 6. JOIN: Visa varje beställning med kundens namn och totalt belopp
SELECT o.id AS order_id,
       o.order_date,
       o.status,
       o.total_amount,
       c.first_name || ' ' || c.last_name AS customer_name
FROM orders o
JOIN customers c ON c.id = o.customer_id
ORDER BY o.order_date DESC;

-- 7. JOIN: Visa vilka produkter varje kund har köpt
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       p.name AS product_name,
       oi.quantity,
       oi.unit_price,
       (oi.quantity * oi.unit_price) AS line_total
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
ORDER BY customer_name, o.order_date;

-- 8. Aggregering: Räkna antal produkter per tillverkare
SELECT b.name AS brand_name,
       COUNT(p.id) AS product_count
FROM brands b
LEFT JOIN products p ON p.brand_id = b.id
GROUP BY b.name
ORDER BY product_count DESC;

-- 9. Aggregering: Hitta kunderna som spenderat mest totalt
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       SUM(o.total_amount) AS total_spent,
       COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 10. Aggregering: Visa produkter med genomsnittligt betyg från recensioner
SELECT p.name AS product_name,
       ROUND(AVG(r.rating)::numeric, 2) AS average_rating,
       COUNT(r.id) AS review_count
FROM products p
LEFT JOIN reviews r ON r.product_id = p.id
GROUP BY p.name
HAVING COUNT(r.id) > 0
ORDER BY average_rating DESC, review_count DESC;
