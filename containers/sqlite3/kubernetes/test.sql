-- SQLite3 Test Script
CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT);
INSERT INTO users(name) VALUES ('Alice');
INSERT INTO users(name) VALUES ('Bob');
INSERT INTO users(name) VALUES ('Charlie');
SELECT 'All users:' as info;
SELECT * FROM users;
SELECT 'Total users:' as info, COUNT(*) as count FROM users;
