-- Simple Hello World program in PostgreSQL
-- This script demonstrates basic PostgreSQL operations

-- Create a simple table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO users (name, email) VALUES 
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com'),
    ('Bob Johnson', 'bob@example.com')
ON CONFLICT (email) DO NOTHING;

-- Display a welcome message
DO $$
BEGIN
    RAISE NOTICE 'Hello, World!';
    RAISE NOTICE 'Welcome to PostgreSQL!';
    RAISE NOTICE 'Database initialized successfully!';
END $$;

-- Show the users table
SELECT * FROM users;

-- Count total users
SELECT COUNT(*) as total_users FROM users;
