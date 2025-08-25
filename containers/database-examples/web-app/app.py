#!/usr/bin/env python3
"""
Web Application for Cross-Language Database Examples

This Flask app provides a web interface to:
- View all users in the database
- Add new users
- Delete users
- Reset the database

Run with: python app.py
Access at: http://localhost:5000
"""

from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
import sqlite3
import os
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'  # Required for flash messages

DATABASE = 'users.db'

def init_db():
    """Initialize the database with sample data"""
    # Remove existing database if it exists
    if os.path.exists(DATABASE):
        os.remove(DATABASE)
    
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    
    # Create users table
    create_table_sql = """
    CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """
    
    cursor.execute(create_table_sql)
    
    # Insert sample users
    sample_users = [
        ("John Doe", "john@example.com"),
        ("Jane Smith", "jane@example.com"),
        ("Bob Johnson", "bob@example.com")
    ]
    
    for name, email in sample_users:
        cursor.execute("INSERT INTO users (name, email) VALUES (?, ?)", (name, email))
    
    conn.commit()
    conn.close()

def get_db_connection():
    """Get a database connection"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row  # This enables column access by name
    return conn

@app.route('/')
def index():
    """Home page - display all users"""
    conn = get_db_connection()
    users = conn.execute('SELECT * FROM users ORDER BY created_at DESC').fetchall()
    conn.close()
    return render_template('index.html', users=users)

@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    """Add a new user"""
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        
        if not name or not email:
            flash('Name and email are required!', 'error')
            return redirect(url_for('add_user'))
        
        try:
            conn = get_db_connection()
            conn.execute('INSERT INTO users (name, email) VALUES (?, ?)', (name, email))
            conn.commit()
            conn.close()
            flash('User added successfully!', 'success')
        except sqlite3.IntegrityError:
            flash('Email already exists!', 'error')
        except Exception as e:
            flash(f'Error adding user: {str(e)}', 'error')
        
        return redirect(url_for('index'))
    
    return render_template('add_user.html')

@app.route('/delete_user/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    """Delete a user"""
    try:
        conn = get_db_connection()
        conn.execute('DELETE FROM users WHERE id = ?', (user_id,))
        conn.commit()
        conn.close()
        flash('User deleted successfully!', 'success')
    except Exception as e:
        flash(f'Error deleting user: {str(e)}', 'error')
    
    return redirect(url_for('index'))

@app.route('/reset_db', methods=['POST'])
def reset_db():
    """Reset the database with sample data"""
    try:
        init_db()
        flash('Database reset successfully!', 'success')
    except Exception as e:
        flash(f'Error resetting database: {str(e)}', 'error')
    
    return redirect(url_for('index'))

@app.route('/api/users')
def api_users():
    """API endpoint to get all users as JSON"""
    conn = get_db_connection()
    users = conn.execute('SELECT * FROM users ORDER BY created_at DESC').fetchall()
    conn.close()
    
    user_list = []
    for user in users:
        user_list.append({
            'id': user['id'],
            'name': user['name'],
            'email': user['email'],
            'created_at': user['created_at']
        })
    
    return jsonify(user_list)

@app.route('/api/users', methods=['POST'])
def api_add_user():
    """API endpoint to add a user via JSON"""
    data = request.get_json()
    
    if not data or 'name' not in data or 'email' not in data:
        return jsonify({'error': 'Name and email are required'}), 400
    
    try:
        conn = get_db_connection()
        cursor = conn.execute('INSERT INTO users (name, email) VALUES (?, ?)', 
                            (data['name'], data['email']))
        conn.commit()
        user_id = cursor.lastrowid
        conn.close()
        
        return jsonify({
            'id': user_id,
            'name': data['name'],
            'email': data['email'],
            'message': 'User added successfully'
        }), 201
    except sqlite3.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 409
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Initialize database on first run
    if not os.path.exists(DATABASE):
        init_db()
        print("Database initialized with sample data")
    
    print("Starting web application...")
    print("Access the application at: http://localhost:5000")
    print("Press Ctrl+C to stop the server")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
