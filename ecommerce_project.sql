-- ==========================================
-- 1. DATABASE & TABLE CREATION SCHEMA
-- ==========================================

CREATE DATABASE IF NOT EXISTS portfolio_ecommerce;
USE portfolio_ecommerce;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE,
    country VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Completed',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


-- ==========================================
-- 2. INSERT MOCK DATA
-- ==========================================

-- Insert Customers
INSERT INTO Customers (first_name, last_name, email, registration_date, country) VALUES
('Ali', 'Khan', 'ali.khan@example.com', '2026-01-10', 'Pakistan'),
('Ayesha', 'Malik', 'ayesha.malik@example.com', '2026-01-15', 'Pakistan'),
('John', 'Doe', 'john.doe@example.com', '2026-02-01', 'USA'),
('Emma', 'Smith', 'emma.smith@example.com', '2026-02-10', 'UK'),
('Hamza', 'Ahmed', 'hamza.ahmed@example.com', '2026-02-20', 'Pakistan');

-- Insert Products
INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Leather Oxford Shoes', 'Footwear', 120.00, 15),
('Running Sneakers', 'Footwear', 85.50, 8),
('Minimalist Watch', 'Accessories', 250.00, 25),
('Canvas Backpack', 'Accessories', 45.00, 5),
('Classic Denim Jacket', 'Apparel', 95.00, 12);

-- Insert Orders
INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, '2026-03-01', 205.50, 'Completed'),
(2, '2026-03-05', 250.00, 'Completed'),
(3, '2026-03-10', 120.00, 'Completed'),
(4, '2026-03-12', 140.00, 'Completed'),
(5, '2026-03-15', 345.00, 'Completed');

-- Insert Order Items
INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 85.50),
(1, 4, 2, 60.00),
(2, 3, 1, 250.00),
(3, 1, 1, 120.00),
(4, 2, 1, 85.50),
(4, 4, 1, 54.50),
(5, 3, 1, 250.00),
(5, 5, 1, 95.00);


-- ==========================================
-- 3. UPDATE EMAILS TO PROFESSIONAL DOMAINS
-- ==========================================

UPDATE Customers SET email = 'ali.khan@gmail.com' WHERE customer_id = 1;
UPDATE Customers SET email = 'ayesha.malik@yahoo.com' WHERE customer_id = 2;
UPDATE Customers SET email = 'john.doe@gmail.com' WHERE customer_id = 3;
UPDATE Customers SET email = 'emma.smith@yahoo.co.uk' WHERE customer_id = 4;
UPDATE Customers SET email = 'hamza.ahmed@gmail.com' WHERE customer_id = 5;


-- ==========================================
-- 4. SHOWCASE ANALYTICAL QUERIES
-- ==========================================

-- Query 1: Monthly Revenue & Order Volume
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS sale_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_amount) AS monthly_revenue
FROM Orders
WHERE status = 'Completed'
GROUP BY sale_month
ORDER BY sale_month DESC;


-- Query 2: Identifying VIP Customers (Using CTEs)
WITH CustomerSpend AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        SUM(o.total_amount) AS total_spent,
        COUNT(o.order_id) AS order_count
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, full_name
)
SELECT * 
FROM CustomerSpend 
WHERE total_spent > 100 
ORDER BY total_spent DESC;


-- Query 3: Low-Stock Inventory Alerts
SELECT 
    p.product_id,
    p.product_name,
    p.stock_quantity,
    COALESCE(SUM(oi.quantity), 0) AS total_sold
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE p.stock_quantity < 20
GROUP BY p.product_id, p.product_name, p.stock_quantity
ORDER BY p.stock_quantity ASC;