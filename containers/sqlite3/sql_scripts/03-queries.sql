-- Basic SELECT queries
SELECT * FROM users;
SELECT * FROM products WHERE category = 'Electronics';
SELECT * FROM orders WHERE status = 'completed';

-- JOIN queries
SELECT 
    u.username,
    u.email,
    o.id as order_id,
    o.total_amount,
    o.status,
    o.order_date
FROM users u
JOIN orders o ON u.id = o.user_id
ORDER BY o.order_date DESC;

-- Complex JOIN with order details
SELECT 
    u.username,
    o.id as order_id,
    p.name as product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) as item_total
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY u.username, o.id;

-- Aggregation queries
SELECT 
    category,
    COUNT(*) as product_count,
    AVG(price) as avg_price,
    MIN(price) as min_price,
    MAX(price) as max_price,
    SUM(stock_quantity) as total_stock
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- User order statistics
SELECT 
    u.username,
    COUNT(o.id) as order_count,
    SUM(o.total_amount) as total_spent,
    AVG(o.total_amount) as avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.username
ORDER BY total_spent DESC;