-- Electronics Shop - Testdata
-- Kör efter schema.sql med anslutning mot electronics_db

SET search_path TO public;

TRUNCATE reviews, order_items, orders, products, brands, customers RESTART IDENTITY CASCADE;

INSERT INTO brands (name, country, founded_year, description)
VALUES
    ('NovaTech', 'USA', 2001, 'Innovativa konsumentelektronik med fokus på smarta enheter.'),
    ('Aurora Electronics', 'Sweden', 2010, 'Skandinavisk design och hållbarhet i premiumsegmentet.'),
    ('Zenith Devices', 'Japan', 1995, 'Avancerad underhållningsteknik och ljudprodukter.');

INSERT INTO products (name, brand_id, sku, release_year, price, warranty_months, category, stock_quantity)
VALUES
    ('NovaTech Pulse X Smartphone', 1, 'NT-PULSEX-5G', 2024, 7999.00, 24, 'Smartphones', 25),
    ('NovaTech AirLite 14 Laptop', 1, 'NT-AIR14-2024', 2023, 12999.00, 36, 'Laptops', 15),
    ('Aurora Tab 10 Tablet', 2, 'AE-TAB10-2023', 2023, 5499.00, 24, 'Tablets', 40),
    ('Aurora SoundBar Pro', 2, 'AE-SBPRO-01', 2022, 3299.00, 18, 'Audio', 18),
    ('Zenith Quantum TV 55"', 3, 'ZD-QTV55-4K', 2024, 9999.00, 36, 'Televisions', 12),
    ('Zenith Breeze Earbuds', 3, 'ZD-BREEZE-BK', 2023, 1499.00, 12, 'Audio', 60),
    ('NovaTech Home Hub', 1, 'NT-HUB-2024', 2024, 2499.00, 24, 'Smart Home', 30),
    ('Aurora Gaming Laptop G17', 2, 'AE-G17-RTX', 2024, 14999.00, 36, 'Laptops', 10),
    ('Zenith SmartWatch S', 3, 'ZD-SMART-S', 2022, 2999.00, 24, 'Wearables', 35),
    ('Aurora Studio Monitor', 2, 'AE-MON-8', 2021, 2199.00, 24, 'Audio', 22);

INSERT INTO customers (first_name, last_name, email, phone, city, registration_date)
VALUES
    ('Emma', 'Andersson', 'emma.andersson@example.com', '070-111 22 33', 'Stockholm', '2022-04-15'),
    ('Johan', 'Nilsson', 'johan.nilsson@example.com', '070-222 33 44', 'Göteborg', '2021-11-08'),
    ('Sara', 'Lind', 'sara.lind@example.com', '070-333 44 55', 'Malmö', '2023-02-10'),
    ('Marcus', 'Östlund', 'marcus.ostlund@example.com', '070-444 55 66', 'Uppsala', '2020-09-22'),
    ('Aisha', 'Hassan', 'aisha.hassan@example.com', '070-555 66 77', 'Linköping', '2024-01-05');

INSERT INTO orders (customer_id, order_date, total_amount, status, shipping_city)
VALUES
    (1, '2024-01-12', 7999.00, 'completed', 'Stockholm'),
    (2, '2024-02-05', 12999.00, 'completed', 'Göteborg'),
    (1, '2024-03-18', 5497.00, 'completed', 'Stockholm'),
    (3, '2024-03-28', 5499.00, 'pending', 'Malmö'),
    (4, '2023-11-22', 12998.00, 'completed', 'Uppsala'),
    (5, '2024-04-10', 14999.00, 'completed', 'Stockholm'),
    (2, '2024-05-02', 4798.00, 'pending', 'Göteborg'),
    (3, '2024-05-18', 4398.00, 'completed', 'Malmö'),
    (5, '2023-12-05', 7999.00, 'cancelled', 'Linköping'),
    (1, '2024-05-25', 14498.00, 'completed', 'Stockholm');

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 1, 7999.00),
    (2, 2, 1, 12999.00),
    (3, 6, 2, 1499.00),
    (3, 7, 1, 2499.00),
    (4, 3, 1, 5499.00),
    (5, 5, 1, 9999.00),
    (5, 9, 1, 2999.00),
    (6, 8, 1, 14999.00),
    (7, 4, 1, 3299.00),
    (7, 6, 1, 1499.00),
    (8, 10, 2, 2199.00),
    (9, 1, 1, 7999.00),
    (10, 2, 1, 12999.00),
    (10, 6, 1, 1499.00);

INSERT INTO reviews (product_id, customer_id, rating, comment, review_date)
VALUES
    (1, 1, 5, 'Snabb och responsiv telefon med grym batteritid.', '2024-01-20'),
    (2, 2, 4, 'Lätt och kraftfull laptop, men något varm under belastning.', '2024-02-12'),
    (3, 3, 5, 'Perfekt för streaming och anteckningar.', '2024-04-02'),
    (4, 2, 3, 'Bra ljud men installationen var krånglig.', '2024-05-05'),
    (5, 4, 5, 'Fantastisk bildkvalitet och smarta funktioner.', '2023-12-01'),
    (6, 5, 4, 'Sköna att bära, lite brus i bullriga miljöer.', '2024-04-20'),
    (7, 1, 5, 'Smidig styrning av hela hemmet.', '2024-03-25'),
    (8, 5, 4, 'Riktigt snabb spelprestanda.', '2024-04-18'),
    (9, 3, 2, 'Batteriet håller inte vad som utlovas.', '2024-02-15'),
    (10, 4, 4, 'Klart och detaljerat ljud i studion.', '2024-05-22');

