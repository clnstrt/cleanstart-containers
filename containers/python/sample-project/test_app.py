#!/usr/bin/env python3
"""
Test suite for Flask User Management Application
Comprehensive tests for all endpoints and functionality.
"""

import os
import tempfile
import pytest
import json
from app import app, get_db_connection, init_db


@pytest.fixture
def client():
    """Create a test client with a temporary database."""
    # Create a temporary file for the test database
    db_fd, app.config['DATABASE'] = tempfile.mkstemp()
    app.config['TESTING'] = True
    
    with app.test_client() as client:
        with app.app_context():
            init_db()
        yield client
    
    # Clean up
    os.close(db_fd)
    os.unlink(app.config['DATABASE'])


def test_index_page(client):
    """Test the home page loads correctly."""
    response = client.get('/')
    assert response.status_code == 200
    assert b'User Management' in response.data or b'Users' in response.data


def test_add_user_page(client):
    """Test the add user page loads correctly."""
    response = client.get('/add')
    assert response.status_code == 200
    assert b'Add User' in response.data or b'name' in response.data


def test_add_user_form_submission(client):
    """Test adding a user via form submission."""
    response = client.post('/add', data={
        'name': 'John Doe',
        'email': 'john@example.com'
    }, follow_redirects=True)
    
    assert response.status_code == 200
    
    # Check if user was added by getting the index page
    response = client.get('/')
    assert b'John Doe' in response.data
    assert b'john@example.com' in response.data


def test_add_user_duplicate_email(client):
    """Test adding a user with duplicate email fails."""
    # Add first user
    client.post('/add', data={
        'name': 'John Doe',
        'email': 'john@example.com'
    })
    
    # Try to add second user with same email
    response = client.post('/add', data={
        'name': 'Jane Doe',
        'email': 'john@example.com'
    })
    
    assert response.status_code == 400
    assert b'Email already exists' in response.data


def test_add_user_missing_fields(client):
    """Test adding a user with missing fields fails."""
    response = client.post('/add', data={
        'name': 'John Doe'
        # Missing email
    })
    
    assert response.status_code == 400
    assert b'Name and email are required' in response.data


def test_get_users_api(client):
    """Test the GET /api/users endpoint."""
    # Add a test user
    client.post('/add', data={
        'name': 'Test User',
        'email': 'test@example.com'
    })
    
    response = client.get('/api/users')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert len(data) == 1
    assert data[0]['name'] == 'Test User'
    assert data[0]['email'] == 'test@example.com'
    assert 'id' in data[0]
    assert 'created_at' in data[0]


def test_create_user_api(client):
    """Test the POST /api/users endpoint."""
    response = client.post('/api/users', 
                          data=json.dumps({
                              'name': 'API User',
                              'email': 'api@example.com'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 201
    
    data = json.loads(response.data)
    assert data['name'] == 'API User'
    assert data['email'] == 'api@example.com'
    assert 'id' in data
    assert 'created_at' in data


def test_create_user_api_missing_fields(client):
    """Test creating user via API with missing fields."""
    response = client.post('/api/users',
                          data=json.dumps({'name': 'Incomplete User'}),
                          content_type='application/json')
    
    assert response.status_code == 400
    
    data = json.loads(response.data)
    assert 'error' in data
    assert 'required' in data['error']


def test_create_user_api_duplicate_email(client):
    """Test creating user via API with duplicate email."""
    # Create first user
    client.post('/api/users',
                data=json.dumps({
                    'name': 'First User',
                    'email': 'duplicate@example.com'
                }),
                content_type='application/json')
    
    # Try to create second user with same email
    response = client.post('/api/users',
                          data=json.dumps({
                              'name': 'Second User',
                              'email': 'duplicate@example.com'
                          }),
                          content_type='application/json')
    
    assert response.status_code == 400
    
    data = json.loads(response.data)
    assert 'error' in data
    assert 'already exists' in data['error']


def test_get_user_by_id(client):
    """Test getting a specific user by ID."""
    # Create a user
    response = client.post('/api/users',
                          data=json.dumps({
                              'name': 'Specific User',
                              'email': 'specific@example.com'
                          }),
                          content_type='application/json')
    
    user_id = json.loads(response.data)['id']
    
    # Get the user by ID
    response = client.get(f'/api/users/{user_id}')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['name'] == 'Specific User'
    assert data['email'] == 'specific@example.com'
    assert data['id'] == user_id


def test_get_user_by_id_not_found(client):
    """Test getting a non-existent user by ID."""
    response = client.get('/api/users/999')
    assert response.status_code == 404
    
    data = json.loads(response.data)
    assert 'error' in data
    assert 'not found' in data['error']


def test_delete_user(client):
    """Test deleting a user by ID."""
    # Create a user
    response = client.post('/api/users',
                          data=json.dumps({
                              'name': 'User to Delete',
                              'email': 'delete@example.com'
                          }),
                          content_type='application/json')
    
    user_id = json.loads(response.data)['id']
    
    # Delete the user
    response = client.delete(f'/api/users/{user_id}')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert 'message' in data
    assert 'deleted' in data['message']
    
    # Verify user is deleted
    response = client.get(f'/api/users/{user_id}')
    assert response.status_code == 404


def test_delete_user_not_found(client):
    """Test deleting a non-existent user."""
    response = client.delete('/api/users/999')
    assert response.status_code == 404
    
    data = json.loads(response.data)
    assert 'error' in data
    assert 'not found' in data['error']


def test_health_check(client):
    """Test the health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'timestamp' in data


def test_database_connection():
    """Test database connection and initialization."""
    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        db_path = tmp.name
    
    try:
        # Test database initialization
        app.config['DATABASE'] = db_path
        with app.app_context():
            init_db()
            
            # Test connection
            conn = get_db_connection()
            cursor = conn.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")
            assert cursor.fetchone() is not None
            conn.close()
    finally:
        os.unlink(db_path)


if __name__ == '__main__':
    pytest.main([__file__, '-v'])
