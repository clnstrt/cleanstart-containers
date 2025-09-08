#!/usr/bin/env python3
"""
PostgreSQL Sample Web Application
A simple Flask app that demonstrates PostgreSQL integration
"""

from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2
import os
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'

# Database configuration
DB_CONFIG = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'database': os.getenv('DB_NAME', 'helloworld'),
    'user': os.getenv('DB_USER', 'postgres'),
    'password': os.getenv('DB_PASSWORD', 'password'),
    'port': os.getenv('DB_PORT', '5432')
}

def get_db_connection():
    """Create database connection"""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except psycopg2.Error as e:
        print(f"Database connection error: {e}")
        return None

def init_database():
    """Initialize database with tables"""
    conn = get_db_connection()
    if conn:
        try:
            cur = conn.cursor()
            
            # Create users table
            cur.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    email VARCHAR(255) UNIQUE NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            # Create posts table
            cur.execute("""
                CREATE TABLE IF NOT EXISTS posts (
                    id SERIAL PRIMARY KEY,
                    title VARCHAR(200) NOT NULL,
                    content TEXT,
                    user_id INTEGER REFERENCES users(id),
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            """)
            
            conn.commit()
            cur.close()
            conn.close()
            print("Database initialized successfully!")
        except psycopg2.Error as e:
            print(f"Database initialization error: {e}")

@app.route('/')
def index():
    """Home page - show all posts"""
    conn = get_db_connection()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("""
                SELECT p.id, p.title, p.content, p.created_at, u.name as author
                FROM posts p
                LEFT JOIN users u ON p.user_id = u.id
                ORDER BY p.created_at DESC
            """)
            posts = cur.fetchall()
            cur.close()
            conn.close()
            return render_template('index.html', posts=posts)
        except psycopg2.Error as e:
            flash(f"Database error: {e}", 'error')
            return render_template('index.html', posts=[])
    else:
        flash("Could not connect to database", 'error')
        return render_template('index.html', posts=[])

@app.route('/users')
def users():
    """Show all users"""
    conn = get_db_connection()
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("SELECT id, name, email, created_at FROM users ORDER BY created_at DESC")
            users = cur.fetchall()
            cur.close()
            conn.close()
            return render_template('users.html', users=users)
        except psycopg2.Error as e:
            flash(f"Database error: {e}", 'error')
            return render_template('users.html', users=[])
    else:
        flash("Could not connect to database", 'error')
        return render_template('users.html', users=[])

@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    """Add a new user"""
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        
        if not name or not email:
            flash('Name and email are required!', 'error')
            return redirect(url_for('add_user'))
        
        conn = get_db_connection()
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO users (name, email) VALUES (%s, %s)", (name, email))
                conn.commit()
                cur.close()
                conn.close()
                flash('User added successfully!', 'success')
                return redirect(url_for('users'))
            except psycopg2.IntegrityError:
                flash('Email already exists!', 'error')
            except psycopg2.Error as e:
                flash(f'Database error: {e}', 'error')
            finally:
                if conn:
                    conn.close()
        
        return redirect(url_for('add_user'))
    
    return render_template('add_user.html')

@app.route('/add_post', methods=['GET', 'POST'])
def add_post():
    """Add a new post"""
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']
        user_id = request.form.get('user_id', 1)  # Default to first user
        
        if not title:
            flash('Title is required!', 'error')
            return redirect(url_for('add_post'))
        
        conn = get_db_connection()
        if conn:
            try:
                cur = conn.cursor()
                cur.execute("INSERT INTO posts (title, content, user_id) VALUES (%s, %s, %s)", 
                          (title, content, user_id))
                conn.commit()
                cur.close()
                conn.close()
                flash('Post added successfully!', 'success')
                return redirect(url_for('index'))
            except psycopg2.Error as e:
                flash(f'Database error: {e}', 'error')
            finally:
                if conn:
                    conn.close()
        
        return redirect(url_for('add_post'))
    
    # Get users for dropdown
    conn = get_db_connection()
    users = []
    if conn:
        try:
            cur = conn.cursor()
            cur.execute("SELECT id, name FROM users ORDER BY name")
            users = cur.fetchall()
            cur.close()
            conn.close()
        except psycopg2.Error as e:
            flash(f'Database error: {e}', 'error')
    
    return render_template('add_post.html', users=users)

@app.route('/health')
def health():
    """Health check endpoint"""
    conn = get_db_connection()
    if conn:
        conn.close()
        return {'status': 'healthy', 'database': 'connected'}, 200
    else:
        return {'status': 'unhealthy', 'database': 'disconnected'}, 500

if __name__ == '__main__':
    # Initialize database on startup
    init_database()
    
    # Run the app
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
