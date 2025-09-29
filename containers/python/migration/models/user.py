import sqlite3
from .database import DB_NAME

class User:
    def __init__(self, name, email, user_id=None):
        self.id = user_id
        self.name = name
        self.email = email

    def save(self):
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        if self.id:
            cursor.execute("UPDATE users SET name=?, email=? WHERE id=?", (self.name, self.email, self.id))
        else:
            cursor.execute("INSERT INTO users (name, email) VALUES (?, ?)", (self.name, self.email))
            self.id = cursor.lastrowid
        conn.commit()
        conn.close()

    def delete(self):
        if self.id:
            conn = sqlite3.connect(DB_NAME)
            cursor = conn.cursor()
            cursor.execute("DELETE FROM users WHERE id=?", (self.id,))
            conn.commit()
            conn.close()

    @staticmethod
    def get_all():
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT id, name, email FROM users")
        rows = cursor.fetchall()
        conn.close()
        return [User(name=row[1], email=row[2], user_id=row[0]) for row in rows]

    @staticmethod
    def get_by_id(user_id):
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT id, name, email FROM users WHERE id=?", (user_id,))
        row = cursor.fetchone()
        conn.close()
        if row:
            return User(name=row[1], email=row[2], user_id=row[0])
        return None
