#!/usr/bin/env python3
"""
SQLite3 Hello World Example
This demonstrates basic SQLite3 database operations
"""

import sqlite3
import os
import time

def create_database():
    """Create a simple database and table"""
    print("🗄️  Creating SQLite3 Database:")
    print("=" * 40)
    
    # Create database file
    db_file = "hello_world.db"
    
    # Remove existing database if it exists
    if os.path.exists(db_file):
        os.remove(db_file)
        print(f"   Removed existing database: {db_file}")
    
    # Connect to database (creates if doesn't exist)
    conn = sqlite3.connect(db_file)
    cursor = conn.cursor()
    
    # Create a simple table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS greetings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            message TEXT NOT NULL,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    print(f"✅ Database created: {db_file}")
    print("✅ Table 'greetings' created")
    
    return conn, cursor

def insert_sample_data(cursor):
    """Insert sample data into the database"""
    print("\n📝 Inserting Sample Data:")
    print("=" * 40)
    
    # Insert sample greetings
    greetings = [
        "Hello, SQLite3!",
        "Welcome to the database world!",
        "SQLite3 is awesome!",
        "Database operations are fun!",
        "CleanStart Containers rock!"
    ]
    
    for greeting in greetings:
        cursor.execute(
            "INSERT INTO greetings (message) VALUES (?)",
            (greeting,)
        )
        print(f"   Inserted: {greeting}")
    
    print(f"✅ Inserted {len(greetings)} records")

def query_data(cursor):
    """Query data from the database"""
    print("\n🔍 Querying Data:")
    print("=" * 40)
    
    # Query all greetings
    cursor.execute("SELECT * FROM greetings ORDER BY timestamp")
    rows = cursor.fetchall()
    
    print("   All greetings:")
    for row in rows:
        print(f"   ID: {row[0]}, Message: {row[1]}, Time: {row[2]}")
    
    print(f"✅ Retrieved {len(rows)} records")
    
    # Count total records
    cursor.execute("SELECT COUNT(*) FROM greetings")
    count = cursor.fetchone()[0]
    print(f"✅ Total records: {count}")

def update_data(cursor):
    """Update data in the database"""
    print("\n✏️  Updating Data:")
    print("=" * 40)
    
    # Update first record
    cursor.execute(
        "UPDATE greetings SET message = ? WHERE id = ?",
        ("Hello, Updated SQLite3!", 1)
    )
    
    print("✅ Updated first record")
    
    # Show updated record
    cursor.execute("SELECT * FROM greetings WHERE id = 1")
    row = cursor.fetchone()
    print(f"   Updated record: {row[1]}")

def delete_data(cursor):
    """Delete data from the database"""
    print("\n🗑️  Deleting Data:")
    print("=" * 40)
    
    # Delete last record
    cursor.execute("DELETE FROM greetings WHERE id = (SELECT MAX(id) FROM greetings)")
    
    print("✅ Deleted last record")
    
    # Show remaining count
    cursor.execute("SELECT COUNT(*) FROM greetings")
    count = cursor.fetchone()[0]
    print(f"✅ Remaining records: {count}")

def demonstrate_advanced_operations(cursor):
    """Demonstrate advanced SQLite3 operations"""
    print("\n🚀 Advanced Operations:")
    print("=" * 40)
    
    # Create a more complex table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            age INTEGER,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Insert user data
    users = [
        ("John Doe", "john@example.com", 30),
        ("Jane Smith", "jane@example.com", 25),
        ("Bob Johnson", "bob@example.com", 35)
    ]
    
    for user in users:
        cursor.execute(
            "INSERT INTO users (name, email, age) VALUES (?, ?, ?)",
            user
        )
    
    print("✅ Created 'users' table with sample data")
    
    # Complex query
    cursor.execute('''
        SELECT name, email, age 
        FROM users 
        WHERE age > 25 
        ORDER BY age DESC
    ''')
    
    rows = cursor.fetchall()
    print("   Users over 25:")
    for row in rows:
        print(f"   {row[0]} ({row[1]}) - Age: {row[2]}")

def main():
    """Main function to run SQLite3 hello world"""
    print("🚀 SQLite3 Hello World Example")
    print("=" * 50)
    
    try:
        # Create database and table
        conn, cursor = create_database()
        
        # Insert sample data
        insert_sample_data(cursor)
        
        # Query data
        query_data(cursor)
        
        # Update data
        update_data(cursor)
        
        # Delete data
        delete_data(cursor)
        
        # Advanced operations
        demonstrate_advanced_operations(cursor)
        
        # Commit changes
        conn.commit()
        
        print("\n🎉 SQLite3 Hello World completed successfully!")
        print("✅ Database operations completed")
        print("✅ Sample data created and manipulated")
        print("✅ Advanced features demonstrated")
        
    except sqlite3.Error as e:
        print(f"❌ Database error: {e}")
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        # Close connection
        if 'conn' in locals():
            conn.close()
            print("✅ Database connection closed")
    
    print("\n📚 Next Steps:")
    print("   1. Explore basic-examples/ for more SQL examples")
    print("   2. Check web-app/ for Flask integration")
    print("   3. Try advanced queries and operations")

if __name__ == "__main__":
    main()
