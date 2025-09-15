-- SQLite3 Hello World Example
-- This demonstrates basic SQLite3 operations

-- Create a simple table
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com'),
    ('Bob Johnson', 'bob@example.com');

-- Query the data
SELECT * FROM users;

-- Update a record
UPDATE users SET name = 'John Updated' WHERE email = 'john@example.com';

-- Delete a record
DELETE FROM users WHERE email = 'bob@example.com';

-- Show final results
SELECT * FROM users;
