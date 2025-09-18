-- Insert sample users
INSERT INTO users (username, email) VALUES 
    ('john_doe', 'john@example.com'),
    ('jane_smith', 'jane@example.com'),
    ('bob_wilson', 'bob@example.com'),
    ('alice_brown', 'alice@example.com'),
    ('charlie_davis', 'charlie@example.com');

-- Insert sample products
INSERT INTO products (name, description, price, category, stock_quantity) VALUES 
    ('Laptop Pro', 'High-performance laptop for professionals', 1299.99, 'Electronics', 50),
    ('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 'Electronics', 150),
    ('Coffee Maker', 'Automatic drip coffee maker', 89.99, 'Home & Kitchen', 75),
    ('Running Shoes', 'Comfortable running shoes', 119.99, 'Sports', 100),
    ('Desk Lamp', 'LED desk lamp with adjustable brightness', 45.99, 'Home & Kitchen', 80),
    ('Smartphone', 'Latest model smartphone', 799.99, 'Electronics', 30),
    ('Water Bottle', 'Insulated stainless steel water bottle', 24.99, 'Sports', 200),
    ('Cookbook', 'Healthy recipes cookbook', 19.99, 'Books', 60);

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, status) VALUES 
    (1, 1329.98, 'completed'),
    (2, 109.98, 'pending'),
    (3, 45.99, 'shipped'),
    (1, 824.98, 'completed'),
    (4, 149.98, 'processing');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
    (1, 1, 1, 1299.99),  -- John's laptop
    (1, 2, 1, 29.99),    -- John's mouse
    (2, 4, 1, 119.99),   -- Jane's shoes
    (2, 7, 4, 24.99),    -- Jane's water bottles
    (3, 5, 1, 45.99),    -- Bob's desk lamp
    (4, 6, 1, 799.99),   -- John's smartphone
    (4, 8, 1, 19.99),    -- John's cookbook
    (5, 3, 1, 89.99),    -- Alice's coffee maker
    (5, 4, 1, 119.99);   -- Alice's shoes