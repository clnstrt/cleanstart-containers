"""
User model for CRUD operations.
"""

from datetime import datetime
from models.database import get_db

class User:
    """User model class with CRUD operations."""
    
    def __init__(self, name, email, age=None, id=None, created_at=None, updated_at=None):
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.created_at = created_at
        self.updated_at = updated_at
    
    def save(self):
        """Save user to database (create or update)."""
        with get_db() as conn:
            if self.id:
                # Update existing user
                conn.execute(
                    'UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?',
                    (self.name, self.email, self.age, self.id)
                )
            else:
                # Create new user
                cursor = conn.execute(
                    'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
                    (self.name, self.email, self.age)
                )
                self.id = cursor.lastrowid
            conn.commit()
    
    def update(self):
        """Update user in database."""
        if not self.id:
            raise ValueError("Cannot update user without ID")
        self.save()
    
    def delete(self):
        """Delete user from database."""
        if not self.id:
            raise ValueError("Cannot delete user without ID")
        
        with get_db() as conn:
            conn.execute('DELETE FROM users WHERE id = ?', (self.id,))
            conn.commit()
    
    @classmethod
    def get_by_id(cls, user_id):
        """Get user by ID."""
        with get_db() as conn:
            row = conn.execute('SELECT * FROM users WHERE id = ?', (user_id,)).fetchone()
            if row:
                return cls._from_row(row)
            return None
    
    @classmethod
    def get_by_email(cls, email):
        """Get user by email."""
        with get_db() as conn:
            row = conn.execute('SELECT * FROM users WHERE email = ?', (email,)).fetchone()
            if row:
                return cls._from_row(row)
            return None
    
    @classmethod
    def get_all(cls):
        """Get all users."""
        with get_db() as conn:
            rows = conn.execute('SELECT * FROM users ORDER BY created_at DESC').fetchall()
            return [cls._from_row(row) for row in rows]
    
    @classmethod
    def search(cls, query):
        """Search users by name or email."""
        with get_db() as conn:
            rows = conn.execute(
                'SELECT * FROM users WHERE name LIKE ? OR email LIKE ? ORDER BY created_at DESC',
                (f'%{query}%', f'%{query}%')
            ).fetchall()
            return [cls._from_row(row) for row in rows]
    
    @classmethod
    def count(cls):
        """Get total number of users."""
        with get_db() as conn:
            result = conn.execute('SELECT COUNT(*) as count FROM users').fetchone()
            return result['count']
    
    @classmethod
    def _from_row(cls, row):
        """Create User instance from database row."""
        return cls(
            id=row['id'],
            name=row['name'],
            email=row['email'],
            age=row['age'],
            created_at=row['created_at'],
            updated_at=row['updated_at']
        )
    
    def to_dict(self):
        """Convert user to dictionary."""
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'age': self.age,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }
    
    def __repr__(self):
        return f"User(id={self.id}, name='{self.name}', email='{self.email}', age={self.age})"
