from flask import Flask, render_template_string, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)

# Configuration from environment variables
DATABASE_PATH = os.getenv('DATABASE_PATH', '/tmp/users.db')
DEBUG_MODE = os.getenv('DEBUG', 'false').lower() == 'true'
HOST = os.getenv('HOST', '0.0.0.0')
PORT = int(os.getenv('PORT', 5000))

def get_connection():
    return sqlite3.connect(DATABASE_PATH)

def create_database():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
        )
    ''')
    conn.commit()
    conn.close()
    print(f"Database created at {DATABASE_PATH}")

def execute_query(query, params=None, fetch=False):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        
        if fetch:
            result = cursor.fetchall()
            conn.close()
            return result
        else:
            conn.commit()
            result = cursor.lastrowid
            conn.close()
            return result
    except Exception as e:
        conn.close()
        raise e

class User:
    def __init__(self, name=None, email=None, user_id=None):
        self.id = user_id
        self.name = name
        self.email = email
    
    def save(self):
        if self.id is None:
            query = "INSERT INTO users (name, email) VALUES (?, ?)"
            self.id = execute_query(query, (self.name, self.email))
        else:
            query = "UPDATE users SET name = ?, email = ? WHERE id = ?"
            execute_query(query, (self.name, self.email, self.id))
    
    def delete(self):
        if self.id:
            query = "DELETE FROM users WHERE id = ?"
            execute_query(query, (self.id,))
    
    @classmethod
    def get_all(cls):
        query = "SELECT id, name, email FROM users ORDER BY id"
        results = execute_query(query, fetch=True)
        return [cls(name=row[1], email=row[2], user_id=row[0]) for row in results]
    
    @classmethod
    def get_by_id(cls, user_id):
        query = "SELECT id, name, email FROM users WHERE id = ?"
        results = execute_query(query, (user_id,), fetch=True)
        if results:
            row = results[0]
            return cls(name=row[1], email=row[2], user_id=row[0])
        return None

# HTML Template
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-section {
            background: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            box-sizing: border-box;
        }
        button {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-right: 10px;
        }
        button:hover {
            background-color: #0056b3;
        }
        .delete-btn {
            background-color: #dc3545;
        }
        .delete-btn:hover {
            background-color: #c82333;
        }
        .update-btn {
            background-color: #28a745;
        }
        .update-btn:hover {
            background-color: #218838;
        }
        .user-row {
            border: 1px solid #e0e0e0;
            margin-bottom: 10px;
            padding: 15px;
            border-radius: 5px;
        }
        .user-actions {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .user-actions form {
            display: inline;
        }
        .edit-form {
            display: none;
            background: #fff;
            padding: 15px;
            border: 2px solid #007bff;
            border-radius: 5px;
            margin-top: 10px;
        }
        .no-users {
            text-align: center;
            color: #666;
            font-style: italic;
            padding: 40px;
        }
        .status {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
    <script>
        function toggleEdit(userId) {
            const editForm = document.getElementById('edit-' + userId);
            const userInfo = document.getElementById('info-' + userId);
            
            if (editForm.style.display === 'none' || editForm.style.display === '') {
                editForm.style.display = 'block';
                userInfo.style.display = 'none';
            } else {
                editForm.style.display = 'none';
                userInfo.style.display = 'block';
            }
        }

        function cancelEdit(userId) {
            const editForm = document.getElementById('edit-' + userId);
            const userInfo = document.getElementById('info-' + userId);
            editForm.style.display = 'none';
            userInfo.style.display = 'block';
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="status">
            ✅ Flask User Management App - Running successfully on Kubernetes!<br>
            🚀 Built with Python using cleanstart/python:latest-dev image
        </div>
        
        <h1>🐍 Python Flask User Management</h1>
        
        <div class="form-section">
            <h2>Add New User</h2>
            <form action="/add" method="post">
                <div class="form-group">
                    <label for="name">Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <button type="submit">Add User</button>
            </form>
        </div>

        <h2>Users List</h2>
        {% if users %}
            {% for user in users %}
            <div class="user-row">
                <div id="info-{{ user.id }}">
                    <strong>{{ user.name }}</strong> - {{ user.email }}
                    <div class="user-actions">
                        <button onclick="toggleEdit({{ user.id }})" class="update-btn">Edit</button>
                        <form action="/delete/{{ user.id }}" method="post" style="display: inline;">
                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this user?')">Delete</button>
                        </form>
                    </div>
                </div>
                
                <div id="edit-{{ user.id }}" class="edit-form">
                    <h3>Edit User</h3>
                    <form action="/update/{{ user.id }}" method="post">
                        <div class="form-group">
                            <label for="edit-name-{{ user.id }}">Name:</label>
                            <input type="text" id="edit-name-{{ user.id }}" name="name" value="{{ user.name }}" required>
                        </div>
                        <div class="form-group">
                            <label for="edit-email-{{ user.id }}">Email:</label>
                            <input type="email" id="edit-email-{{ user.id }}" name="email" value="{{ user.email }}" required>
                        </div>
                        <button type="submit" class="update-btn">Update User</button>
                        <button type="button" onclick="cancelEdit({{ user.id }})">Cancel</button>
                    </form>
                </div>
            </div>
            {% endfor %}
        {% else %}
            <div class="no-users">
                <p>No users found. Add your first user above!</p>
            </div>
        {% endif %}
    </div>
</body>
</html>
'''

# Initialize database when app starts
create_database()

@app.route('/')
def index():
    users = User.get_all()
    return render_template_string(HTML_TEMPLATE, users=users)

@app.route('/add', methods=['POST'])
def add_user():
    name = request.form['name']
    email = request.form['email']
    user = User(name=name, email=email)
    user.save()
    return redirect(url_for('index'))

@app.route('/update/<int:user_id>', methods=['POST'])
def update_user(user_id):
    user = User.get_by_id(user_id)
    if user:
        user.name = request.form['name']
        user.email = request.form['email']
        user.save()
    return redirect(url_for('index'))

@app.route('/delete/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    user = User.get_by_id(user_id)
    if user:
        user.delete()
    return redirect(url_for('index'))

@app.route('/health')
def health_check():
    return {'status': 'healthy', 'database': DATABASE_PATH}, 200

if __name__ == '__main__':
    print("=== Flask User Management App ===")
    print(f"Starting server on {HOST}:{PORT}...")
    print(f"Database path: {DATABASE_PATH}")
    print(f"Working directory: {os.getcwd()}")
    print(f"Debug mode: {DEBUG_MODE}")
    app.run(host=HOST, port=PORT, debug=DEBUG_MODE)