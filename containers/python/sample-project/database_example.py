#!/usr/bin/env python3
"""
Simple Database Example
A basic Python script demonstrating SQLite database operations.
"""

import sqlite3
import os

def create_database():
    """Create database and table."""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # Create users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL
        )
    ''')
    
    conn.commit()
    conn.close()
    print("✅ Database created successfully!")

def add_user(name, email):
    """Add a new user to the database."""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    cursor.execute('INSERT INTO users (name, email) VALUES (?, ?)', (name, email))
    conn.commit()
    conn.close()
    print(f"✅ User '{name}' added successfully!")

def view_all_users():
    """View all users in the database."""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    cursor.execute('SELECT * FROM users')
    users = cursor.fetchall()
    
    if users:
        print("\n📋 All Users:")
        print("-" * 40)
        for user in users:
            print(f"ID: {user[0]}, Name: {user[1]}, Email: {user[2]}")
    else:
        print("📭 No users found in database.")
    
    conn.close()

def delete_user(user_id):
    """Delete a user by ID."""
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    cursor.execute('DELETE FROM users WHERE id = ?', (user_id,))
    conn.commit()
    conn.close()
    print(f"✅ User with ID {user_id} deleted!")

def main():
    """Main function to run the database example."""
    print("🗄️  Simple Database Example")
    print("=" * 30)
    
    # Create database
    create_database()
    
    # Add some sample users
    print("\n📝 Adding sample users...")
    add_user("John Doe", "john@example.com")
    add_user("Jane Smith", "jane@example.com")
    add_user("Bob Johnson", "bob@example.com")
    
    # View all users
    view_all_users()
    
    # Interactive menu
    while True:
        print("\n🔧 What would you like to do?")
        print("1. Add a new user")
        print("2. View all users")
        print("3. Delete a user")
        print("4. Exit")
        
        choice = input("\nEnter your choice (1-4): ").strip()
        
        if choice == '1':
            name = input("Enter name: ").strip()
            email = input("Enter email: ").strip()
            if name and email:
                add_user(name, email)
            else:
                print("❌ Name and email are required!")
        
        elif choice == '2':
            view_all_users()
        
        elif choice == '3':
            view_all_users()
            try:
                user_id = int(input("Enter user ID to delete: ").strip())
                delete_user(user_id)
            except ValueError:
                print("❌ Please enter a valid user ID!")
        
        elif choice == '4':
            print("👋 Goodbye!")
            break
        
        else:
            print("❌ Invalid choice! Please enter 1-4.")

if __name__ == "__main__":
    main()
