-- Create a view for order summaries
CREATE VIEW IF NOT EXISTS order_summary AS
SELECT 
    o.id as order_id,
    u.username,
    u.email,
    o.order_date,
    o.status,
    COUNT(oi.id) as item_count,
    SUM(oi.quantity * oi.unit_price) as calculated_total,
    o.total_amount
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, u.username, u.email, o.order_date, o.status, o.total_amount;

-- Query the view
SELECT * FROM order_summary;

-- Update operations
UPDATE products 
SET stock_quantity = stock_quantity - 1 
WHERE id IN (
    SELECT DISTINCT product_id 
    FROM order_items oi 
    JOIN orders o ON oi.order_id = o.id 
    WHERE o.status = 'completed'
);

-- Create a trigger for automatic timestamp updates
CREATE TRIGGER IF NOT EXISTS update_product_timestamp 
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    UPDATE products 
    SET created_at = CURRENT_TIMESTAMP 
    WHERE id = NEW.id AND OLD.name != NEW.name;
END;

-- Window functions (if supported)
SELECT 
    name,
    category,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) as price_rank,
    AVG(price) OVER (PARTITION BY category) as category_avg_price
FROM products
ORDER BY category, price_rank;

-- Common Table Expression (CTE)
WITH category_stats AS (
    SELECT 
        category,
        COUNT(*) as product_count,
        AVG(price) as avg_price
    FROM products
    GROUP BY category
)
SELECT 
    p.name,
    p.category,
    p.price,
    cs.product_count,
    cs.avg_price,
    CASE 
        WHEN p.price > cs.avg_price THEN 'Above Average'
        WHEN p.price < cs.avg_price THEN 'Below Average'
        ELSE 'Average'
    END as price_category
FROM products p
JOIN category_stats cs ON p.category = cs.category
ORDER BY p.category, p.price DESC;

-- Full-text search setup (if FTS is available)
CREATE VIRTUAL TABLE IF NOT EXISTS products_fts USING fts5(name, description);

INSERT INTO products_fts (name, description)
SELECT name, description FROM products;

-- Search example
-- SELECT * FROM products_fts WHERE products_fts MATCH 'laptop OR smartphone';