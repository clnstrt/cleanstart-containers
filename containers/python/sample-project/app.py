#!/usr/bin/env python3
"""
Sample CRUD Application
A Flask-based web application demonstrating CRUD operations with SQLite database.
"""

from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from models.database import init_db, get_db_connection
from models.user import User
import os

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'

# Initialize database
init_db()

@app.route('/')
def index():
    """Home page with list of all users."""
    try:
        users = User.get_all()
        return render_template('index.html', users=users)
    except Exception as e:
        flash(f'Error loading users: {str(e)}', 'error')
        return render_template('index.html', users=[])

@app.route('/users')
def list_users():
    """API endpoint to get all users as JSON."""
    try:
        users = User.get_all()
        return jsonify([user.to_dict() for user in users])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users/new', methods=['GET', 'POST'])
def create_user():
    """Create a new user."""
    if request.method == 'POST':
        try:
            name = request.form.get('name', '').strip()
            email = request.form.get('email', '').strip()
            age = request.form.get('age', '').strip()
            
            if not name or not email:
                flash('Name and email are required!', 'error')
                return render_template('create_user.html')
            
            # Validate age
            try:
                age = int(age) if age else None
            except ValueError:
                flash('Age must be a valid number!', 'error')
                return render_template('create_user.html')
            
            user = User(name=name, email=email, age=age)
            user.save()
            flash('User created successfully!', 'success')
            return redirect(url_for('index'))
            
        except Exception as e:
            flash(f'Error creating user: {str(e)}', 'error')
            return render_template('create_user.html')
    
    return render_template('create_user.html')

@app.route('/users/<int:user_id>')
def get_user(user_id):
    """Get a specific user by ID."""
    try:
        user = User.get_by_id(user_id)
        if user:
            return jsonify(user.to_dict())
        else:
            return jsonify({'error': 'User not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/users/<int:user_id>/edit', methods=['GET', 'POST'])
def edit_user(user_id):
    """Edit an existing user."""
    user = User.get_by_id(user_id)
    if not user:
        flash('User not found!', 'error')
        return redirect(url_for('index'))
    
    if request.method == 'POST':
        try:
            name = request.form.get('name', '').strip()
            email = request.form.get('email', '').strip()
            age = request.form.get('age', '').strip()
            
            if not name or not email:
                flash('Name and email are required!', 'error')
                return render_template('edit_user.html', user=user)
            
            # Validate age
            try:
                age = int(age) if age else None
            except ValueError:
                flash('Age must be a valid number!', 'error')
                return render_template('edit_user.html', user=user)
            
            user.name = name
            user.email = email
            user.age = age
            user.update()
            flash('User updated successfully!', 'success')
            return redirect(url_for('index'))
            
        except Exception as e:
            flash(f'Error updating user: {str(e)}', 'error')
            return render_template('edit_user.html', user=user)
    
    return render_template('edit_user.html', user=user)

@app.route('/users/<int:user_id>/delete', methods=['POST'])
def delete_user(user_id):
    """Delete a user."""
    try:
        user = User.get_by_id(user_id)
        if user:
            user.delete()
            flash('User deleted successfully!', 'success')
        else:
            flash('User not found!', 'error')
    except Exception as e:
        flash(f'Error deleting user: {str(e)}', 'error')
    
    return redirect(url_for('index'))

@app.route('/api/users', methods=['POST'])
def api_create_user():
    """API endpoint to create a new user."""
    try:
        data = request.get_json()
        if not data or not data.get('name') or not data.get('email'):
            return jsonify({'error': 'Name and email are required'}), 400
        
        user = User(
            name=data['name'],
            email=data['email'],
            age=data.get('age')
        )
        user.save()
        return jsonify(user.to_dict()), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/users/<int:user_id>', methods=['PUT'])
def api_update_user(user_id):
    """API endpoint to update a user."""
    try:
        user = User.get_by_id(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        if 'name' in data:
            user.name = data['name']
        if 'email' in data:
            user.email = data['email']
        if 'age' in data:
            user.age = data['age']
        
        user.update()
        return jsonify(user.to_dict())
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def api_delete_user(user_id):
    """API endpoint to delete a user."""
    try:
        user = User.get_by_id(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        user.delete()
        return jsonify({'message': 'User deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health_check():
    """Health check endpoint."""
    return jsonify({'status': 'healthy', 'message': 'CRUD API is running'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
