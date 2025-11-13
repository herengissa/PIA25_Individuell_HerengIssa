-- Electronics Shop - Avancerade SQL-queries (Del 2, VG)
-- Kör efter schema.sql och testdata.sql i databasen electronics_db

SET search_path TO public;

/* 1. Subquery: Produkter vars pris är högre än genomsnittspriset */
SELECT id,
       name,
       price,
       category
FROM products
WHERE price > (
    SELECT AVG(price) FROM products
)
ORDER BY price DESC;

/* 2. Subquery: Kunder som har beställt fler order än genomsnittet */
SELECT c.id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, customer_name
HAVING COUNT(o.id) > (
    SELECT AVG(order_ct) FROM (
        SELECT COUNT(*) AS order_ct
        FROM orders
        GROUP BY customer_id
    ) avg_orders
)
ORDER BY order_count DESC;

/* 3. Window function: Ranka produkter per tillverkare baserat på pris */
SELECT b.name AS brand_name,
       p.name AS product_name,
       p.price,
       ROW_NUMBER() OVER (PARTITION BY b.id ORDER BY p.price DESC) AS price_rank
FROM products p
JOIN brands b ON b.id = p.brand_id
ORDER BY brand_name, price_rank;

/* 4. Window function: Kunders totala spendering och deras rank */
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       SUM(o.total_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spending_rank
FROM customers c
JOIN orders o ON o.customer_id = c.id
WHERE o.status IN ('completed', 'pending')
GROUP BY customer_name
ORDER BY spending_rank;

/* 5. CASE: Kategorisera produkter efter prisnivå */
SELECT name,
       price,
       CASE
           WHEN price < 1000 THEN 'Budget'
           WHEN price BETWEEN 1000 AND 5000 THEN 'Medium'
           ELSE 'Premium'
       END AS price_segment
FROM products
ORDER BY price;

/* 6. CASE + aggregering: Kundstatus baserat på antal beställningar */
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(o.id) AS order_count,
       CASE
           WHEN COUNT(o.id) > 3 THEN 'VIP'
           WHEN COUNT(o.id) BETWEEN 2 AND 3 THEN 'Regular'
           WHEN COUNT(o.id) = 1 THEN 'New'
           ELSE 'Prospect'
       END AS customer_segment
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY customer_name
ORDER BY order_count DESC, customer_name;

