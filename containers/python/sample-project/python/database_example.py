#!/usr/bin/env python3
"""
Python SQLite Database Example

This script demonstrates basic SQLite operations:
- Creating a database and table
- Inserting user records
- Querying and displaying all users

Requirements: Python 3.x (sqlite3 module is built-in)
"""

import sqlite3
import os

def create_database():
    """Create a new SQLite database and users table"""
    # Remove existing database file if it exists
    if os.path.exists('users.db'):
        os.remove('users.db')
    
    # Connect to database (creates it if it doesn't exist)
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # Create users table
    create_table_sql = """
    CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE
    )
    """
    
    cursor.execute(create_table_sql)
    conn.commit()
    print("Database created successfully")
    print("Table created successfully")
    
    return conn, cursor

def insert_user(cursor, conn, name, email):
    """Insert a new user into the database"""
    insert_sql = "INSERT INTO users (name, email) VALUES (?, ?)"
    cursor.execute(insert_sql, (name, email))
    conn.commit()
    print("User inserted successfully")

def get_all_users(cursor):
    """Query and return all users from the database"""
    cursor.execute("SELECT id, name, email FROM users")
    return cursor.fetchall()

def display_users(users):
    """Display all users in a formatted way"""
    print("All users:")
    for user in users:
        print(f"ID: {user[0]}, Name: {user[1]}, Email: {user[2]}")

def main():
    """Main function to demonstrate database operations"""
    try:
        # Create database and table
        conn, cursor = create_database()
        
        # Insert sample users
        insert_user(cursor, conn, "John Doe", "john@example.com")
        insert_user(cursor, conn, "Jane Smith", "jane@example.com")
        insert_user(cursor, conn, "Bob Johnson", "bob@example.com")
        
        # Query and display all users
        users = get_all_users(cursor)
        display_users(users)
        
        # Close database connection
        conn.close()
        print("Database connection closed")
        
    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
