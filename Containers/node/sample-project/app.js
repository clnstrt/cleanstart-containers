#!/usr/bin/env node

const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const methodOverride = require('method-override');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;
const DATABASE = 'users.db';

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(methodOverride('_method'));
app.use(express.static('public'));

// View engine setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Database setup
const db = new sqlite3.Database(DATABASE, (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        console.log('Connected to SQLite database.');
        initDatabase();
    }
});

// Initialize database
function initDatabase() {
    const sql = `
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    `;
    
    db.run(sql, (err) => {
        if (err) {
            console.error('Error creating table:', err.message);
        } else {
            console.log('Users table created or already exists.');
        }
    });
}

// Routes

// Home page - display all users
app.get('/', (req, res) => {
    const sql = 'SELECT * FROM users ORDER BY created_at DESC';
    
    db.all(sql, [], (err, users) => {
        if (err) {
            console.error('Error fetching users:', err.message);
            res.status(500).json({ error: 'Database error' });
        } else {
            res.render('index', { users: users || [] });
        }
    });
});

// Add user form
app.get('/add', (req, res) => {
    res.render('add_user', { error: null });
});

// Add user
app.post('/add', (req, res) => {
    const { name, email } = req.body;
    
    if (!name || !email) {
        return res.render('add_user', { error: 'Name and email are required!' });
    }
    
    const sql = 'INSERT INTO users (name, email) VALUES (?, ?)';
    
    db.run(sql, [name.trim(), email.trim()], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                res.render('add_user', { error: 'Email already exists!' });
            } else {
                console.error('Error inserting user:', err.message);
                res.render('add_user', { error: 'Database error' });
            }
        } else {
            res.redirect('/');
        }
    });
});

// Delete user
app.post('/delete/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'DELETE FROM users WHERE id = ?';
    
    db.run(sql, [id], (err) => {
        if (err) {
            console.error('Error deleting user:', err.message);
        }
        res.redirect('/');
    });
});

// Reset database
app.post('/reset', (req, res) => {
    const sql = 'DELETE FROM users';
    
    db.run(sql, (err) => {
        if (err) {
            console.error('Error resetting database:', err.message);
        }
        res.redirect('/');
    });
});

// API Routes

// Get all users
app.get('/api/users', (req, res) => {
    const sql = 'SELECT * FROM users ORDER BY created_at DESC';
    
    db.all(sql, [], (err, users) => {
        if (err) {
            console.error('Error fetching users:', err.message);
            res.status(500).json({ error: 'Database error' });
        } else {
            res.json(users || []);
        }
    });
});

// Create user
app.post('/api/users', (req, res) => {
    const { name, email } = req.body;
    
    if (!name || !email) {
        return res.status(400).json({ error: 'Name and email are required' });
    }
    
    const sql = 'INSERT INTO users (name, email) VALUES (?, ?)';
    
    db.run(sql, [name.trim(), email.trim()], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                res.status(400).json({ error: 'Email already exists' });
            } else {
                console.error('Error inserting user:', err.message);
                res.status(500).json({ error: 'Database error' });
            }
        } else {
            // Get the created user
            const selectSql = 'SELECT * FROM users WHERE id = ?';
            db.get(selectSql, [this.lastID], (err, user) => {
                if (err) {
                    console.error('Error fetching created user:', err.message);
                    res.status(500).json({ error: 'Database error' });
                } else {
                    res.status(201).json(user);
                }
            });
        }
    });
});

// Get specific user
app.get('/api/users/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'SELECT * FROM users WHERE id = ?';
    
    db.get(sql, [id], (err, user) => {
        if (err) {
            console.error('Error fetching user:', err.message);
            res.status(500).json({ error: 'Database error' });
        } else if (!user) {
            res.status(404).json({ error: 'User not found' });
        } else {
            res.json(user);
        }
    });
});

// Delete user
app.delete('/api/users/:id', (req, res) => {
    const { id } = req.params;
    const sql = 'DELETE FROM users WHERE id = ?';
    
    db.run(sql, [id], function(err) {
        if (err) {
            console.error('Error deleting user:', err.message);
            res.status(500).json({ error: 'Database error' });
        } else if (this.changes === 0) {
            res.status(404).json({ error: 'User not found' });
        } else {
            res.json({ message: 'User deleted successfully' });
        }
    });
});

// Health check
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString()
    });
});

// Error handlers
app.use((req, res) => {
    res.status(404).json({ error: 'Not found' });
});

app.use((err, req, res, next) => {
    console.error('Error:', err.stack);
    res.status(500).json({ error: 'Internal server error' });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://localhost:${PORT}`);
    console.log(`Health check: http://localhost:${PORT}/health`);
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\nShutting down gracefully...');
    db.close((err) => {
        if (err) {
            console.error('Error closing database:', err.message);
        } else {
            console.log('Database connection closed.');
        }
        process.exit(0);
    });
});
