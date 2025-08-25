const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

// Database setup
const dbPath = 'users.db';
let db;

// Initialize database
function initializeDatabase() {
    return new Promise((resolve, reject) => {
        // Remove existing database file if it exists
        if (fs.existsSync(dbPath)) {
            fs.unlinkSync(dbPath);
        }
        
        // Create new database connection
        db = new sqlite3.Database(dbPath, (err) => {
            if (err) {
                reject(err);
                return;
            }
            
            // Create users table
            const createTableSql = `
                CREATE TABLE users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    email TEXT NOT NULL UNIQUE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            `;
            
            db.run(createTableSql, (err) => {
                if (err) {
                    reject(err);
                    return;
                }
                
                // Insert sample data
                insertSampleData().then(() => {
                    console.log('Database initialized with sample data');
                    resolve();
                }).catch(reject);
            });
        });
    });
}

// Insert sample data
function insertSampleData() {
    return new Promise((resolve, reject) => {
        const users = [
            ['John Doe', 'john@example.com'],
            ['Jane Smith', 'jane@example.com'],
            ['Bob Johnson', 'bob@example.com']
        ];
        
        const insertSql = 'INSERT INTO users (name, email) VALUES (?, ?)';
        let completed = 0;
        
        users.forEach(([name, email]) => {
            db.run(insertSql, [name, email], (err) => {
                if (err) {
                    reject(err);
                    return;
                }
                completed++;
                if (completed === users.length) {
                    resolve();
                }
            });
        });
    });
}

// Routes
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API Routes
app.get('/api/users', (req, res) => {
    const selectSql = 'SELECT id, name, email, created_at FROM users ORDER BY id';
    db.all(selectSql, [], (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json(rows);
    });
});

app.post('/api/users', (req, res) => {
    const { name, email } = req.body;
    
    if (!name || !email) {
        res.status(400).json({ error: 'Name and email are required' });
        return;
    }
    
    const insertSql = 'INSERT INTO users (name, email) VALUES (?, ?)';
    db.run(insertSql, [name, email], function(err) {
        if (err) {
            if (err.message.includes('UNIQUE constraint failed')) {
                res.status(400).json({ error: 'Email already exists' });
            } else {
                res.status(500).json({ error: err.message });
            }
            return;
        }
        res.json({ 
            id: this.lastID, 
            name, 
            email, 
            message: 'User added successfully' 
        });
    });
});

app.delete('/api/users/:id', (req, res) => {
    const { id } = req.params;
    const deleteSql = 'DELETE FROM users WHERE id = ?';
    
    db.run(deleteSql, [id], function(err) {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (this.changes === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }
        res.json({ message: 'User deleted successfully' });
    });
});

app.post('/api/reset', (req, res) => {
    // Close current database connection
    db.close((err) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        
        // Reinitialize database
        initializeDatabase().then(() => {
            res.json({ message: 'Database reset successfully' });
        }).catch((err) => {
            res.status(500).json({ error: err.message });
        });
    });
});

// Start server
async function startServer() {
    try {
        await initializeDatabase();
        
        app.listen(PORT, () => {
            console.log(`🚀 JavaScript Database Web App running on http://localhost:${PORT}`);
            console.log(`📊 Database initialized with sample data`);
            console.log(`🌐 Open your browser and go to: http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error('Failed to start server:', error);
        process.exit(1);
    }
}

startServer();
