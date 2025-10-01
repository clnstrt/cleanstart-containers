-- SQLite3 Demo Script
CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT);
INSERT INTO users(name) VALUES ('Alice');
INSERT INTO users(name) VALUES ('Bob');
SELECT * FROM users;
UPDATE users SET name='Charlie' WHERE name='Alice';
SELECT * FROM users;
DELETE FROM users WHERE name='Bob';
SELECT * FROM users;

