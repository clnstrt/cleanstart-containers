-- Insert data into the users table using INSERT OR IGNORE
INSERT OR IGNORE INTO users (username, email) VALUES ('alice', 'alice@example.com');
INSERT OR IGNORE INTO users (username, email) VALUES ('bob', 'bob@example.com');
INSERT OR IGNORE INTO users (username, email) VALUES ('charlie', 'charlie@example.com');
INSERT OR IGNORE INTO users (username, email) VALUES ('rahul', 'rahul@example.com');
INSERT OR IGNORE INTO users (username, email) VALUES ('raj', 'raj@example.com');
INSERT OR IGNORE INTO users (username, email) VALUES ('ram', 'ram@example.com');

-- Insert data into the products table (this table does not have a UNIQUE constraint, so it's fine)
INSERT INTO products (name, price, stock) VALUES ('Laptop', 1200.00, 50);
INSERT INTO products (name, price, stock) VALUES ('Mouse', 13000.50, 200);
INSERT INTO products (name, price, stock) VALUES ('Keyboard', 1400.00, 150);
INSERT INTO products (name, price, stock) VALUES ('Speaker', 1500.00, 100);
INSERT INTO products (name, price, stock) VALUES ('Router', 2000.00, 100);
INSERT INTO products (name, price, stock) VALUES ('Switch', 2100.00, 100);
INSERT INTO products (name, price, stock) VALUES ('Firewall', 2200.00, 100);
INSERT INTO products (name, price, stock) VALUES ('UPS', 2300.00, 100);
INSERT INTO products (name, price, stock) VALUES ('Server', 2400.00, 100);
INSERT INTO products (name, price, stock) VALUES ('Storage', 2500.00, 100);
