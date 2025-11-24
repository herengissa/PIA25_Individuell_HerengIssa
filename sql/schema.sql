-- Schema för Electronics Shop databas
-- Skapa databasen electronics_db först, sen kör detta script

DROP DATABASE IF EXISTS electronics_db;
CREATE DATABASE electronics_db;

-- Byt till electronics_db innan du kör resten
-- I pgAdmin: högerklicka på electronics_db -> Query Tool
-- I psql: \connect electronics_db

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
SET search_path TO public;

-- Tabell för varumärken
CREATE TABLE brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    country VARCHAR(80),
    founded_year INT,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabell för produkter
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    brand_id INT NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
    sku VARCHAR(80) UNIQUE,
    release_year INT,
    price NUMERIC(10,2) NOT NULL CHECK (price > 0),
    warranty_months INT,
    category VARCHAR(80),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabell för kunder
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(30),
    city VARCHAR(80),
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabell för beställningar
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    status VARCHAR(40) NOT NULL DEFAULT 'pending',
    shipping_city VARCHAR(80),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabell för orderrader
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price > 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabell för recensioner
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    customer_id INT NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, customer_id)
);

-- Index för bättre prestanda
CREATE INDEX idx_products_brand_id ON products(brand_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_reviews_product_id ON reviews(product_id);
CREATE INDEX idx_reviews_customer_id ON reviews(customer_id);
