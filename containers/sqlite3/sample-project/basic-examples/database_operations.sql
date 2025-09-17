-- SQLite3 Database Operations Example
-- This demonstrates various database operations

-- Create a products table
CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category TEXT,
    stock_quantity INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create an orders table
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample products
INSERT INTO products (name, price, category, stock_quantity) VALUES 
    ('Laptop', 999.99, 'Electronics', 10),
    ('Mouse', 29.99, 'Electronics', 50),
    ('Keyboard', 79.99, 'Electronics', 25),
    ('Monitor', 299.99, 'Electronics', 15);

-- Insert sample orders
INSERT INTO orders (user_id, product_id, quantity, total_price) VALUES 
    (1, 1, 1, 999.99),
    (2, 2, 2, 59.98),
    (1, 3, 1, 79.99);

-- Complex queries
-- Find products with low stock
SELECT name, stock_quantity FROM products WHERE stock_quantity < 20;

-- Find total sales by user
SELECT u.name, SUM(o.total_price) as total_spent
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Find most popular products
SELECT p.name, SUM(o.quantity) as total_ordered
FROM products p
JOIN orders o ON p.id = o.product_id
GROUP BY p.id, p.name
ORDER BY total_ordered DESC;
