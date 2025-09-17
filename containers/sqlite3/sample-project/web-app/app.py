#!/usr/bin/env python3
"""
SQLite3 Web Application Example
A simple Flask web app that demonstrates SQLite3 database operations
"""

from flask import Flask, render_template, request, jsonify
import sqlite3
import os

app = Flask(__name__)

# Database file path
DB_FILE = 'app.db'

def init_db():
    """Initialize the database with sample data"""
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    
    # Create users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create posts table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            user_id INTEGER,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id)
        )
    ''')
    
    # Insert sample data
    cursor.execute('''
        INSERT OR IGNORE INTO users (name, email) VALUES 
        ('John Doe', 'john@example.com'),
        ('Jane Smith', 'jane@example.com')
    ''')
    
    cursor.execute('''
        INSERT OR IGNORE INTO posts (title, content, user_id) VALUES 
        ('Hello World', 'This is my first post!', 1),
        ('Python Tips', 'Here are some useful Python tips...', 2)
    ''')
    
    conn.commit()
    conn.close()

@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')

@app.route('/api/users')
def get_users():
    """Get all users"""
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users')
    users = cursor.fetchall()
    conn.close()
    
    return jsonify([{
        'id': user[0],
        'name': user[1],
        'email': user[2],
        'created_at': user[3]
    } for user in users])

@app.route('/api/posts')
def get_posts():
    """Get all posts with user information"""
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    cursor.execute('''
        SELECT p.id, p.title, p.content, p.created_at, u.name as author
        FROM posts p
        JOIN users u ON p.user_id = u.id
        ORDER BY p.created_at DESC
    ''')
    posts = cursor.fetchall()
    conn.close()
    
    return jsonify([{
        'id': post[0],
        'title': post[1],
        'content': post[2],
        'created_at': post[3],
        'author': post[4]
    } for post in posts])

@app.route('/api/users', methods=['POST'])
def create_user():
    """Create a new user"""
    data = request.get_json()
    
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            'INSERT INTO users (name, email) VALUES (?, ?)',
            (data['name'], data['email'])
        )
        conn.commit()
        user_id = cursor.lastrowid
        conn.close()
        
        return jsonify({'id': user_id, 'message': 'User created successfully'}), 201
    except sqlite3.IntegrityError:
        conn.close()
        return jsonify({'error': 'Email already exists'}), 400

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
