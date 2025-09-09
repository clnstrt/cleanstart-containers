-- PostgreSQL Database Initialization Script
-- This script sets up the database schema for the Kubernetes PostgreSQL example

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table with user relationship
CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id);
CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at);

-- Insert sample data
INSERT INTO users (name, email, phone) VALUES 
    ('John Doe', 'john.doe@example.com', '123-456-7890'),
    ('Jane Smith', 'jane.smith@example.com', '987-654-3210'),
    ('Bob Johnson', 'bob.johnson@example.com', '555-123-4567')
ON CONFLICT (email) DO NOTHING;

-- Insert sample posts
INSERT INTO posts (title, content, user_id) VALUES 
    ('Welcome to Kubernetes PostgreSQL!', 'This is a sample post to demonstrate the database setup.', 1),
    ('Getting Started with PostgreSQL', 'PostgreSQL is a powerful, open source object-relational database system.', 1),
    ('Kubernetes Database Management', 'Learn how to manage databases in Kubernetes environments.', 2),
    ('Database Best Practices', 'Here are some best practices for database design and management.', 3)
ON CONFLICT DO NOTHING;

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON posts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Grant necessary permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;

-- Display success message
DO $$
BEGIN
    RAISE NOTICE 'PostgreSQL database initialization completed successfully!';
    RAISE NOTICE 'Database: helloworld';
    RAISE NOTICE 'Tables created: users, posts';
    RAISE NOTICE 'Sample data inserted successfully';
END $$;
