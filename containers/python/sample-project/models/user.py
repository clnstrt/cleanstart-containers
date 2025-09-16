from models.database import get_db_connection

class User:
    def __init__(self, name, email, user_id=None):
        self.user_id = user_id
        self.name = name
        self.email = email

    def save(self):
        conn = get_db_connection()
        if self.user_id is None:
            conn.execute("INSERT INTO users (name, email) VALUES (?, ?)", (self.name, self.email))
        else:
            conn.execute("UPDATE users SET name = ?, email = ? WHERE id = ?", (self.name, self.email, self.user_id))
        conn.commit()
        conn.close()

    def delete(self):
        if self.user_id:
            conn = get_db_connection()
            conn.execute("DELETE FROM users WHERE id = ?", (self.user_id,))
            conn.commit()
            conn.close()

    @staticmethod
    def get_all():
        conn = get_db_connection()
        users = conn.execute("SELECT * FROM users").fetchall()
        conn.close()
        return users

    @staticmethod
    def get_by_id(user_id):
        conn = get_db_connection()
        user_data = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,)).fetchone()
        conn.close()
        if user_data:
            return User(user_data['name'], user_data['email'], user_data['id'])
        return None