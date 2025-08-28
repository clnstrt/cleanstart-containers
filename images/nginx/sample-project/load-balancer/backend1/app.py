#!/usr/bin/env python3
"""
Flask API for Nginx Load Balancer Example - Backend 1
This demonstrates a backend service that can be load balanced by nginx.
"""

from flask import Flask, jsonify, request
from datetime import datetime
import os
import json
import socket

app = Flask(__name__)

# Get server configuration from environment
SERVER_ID = os.environ.get('SERVER_ID', '1')
PORT = int(os.environ.get('PORT', 8001))
HOSTNAME = socket.gethostname()

# Sample data
users = [
    {"id": 1, "name": "John Doe", "email": "john@example.com", "created_at": "2024-01-01T10:00:00Z"},
    {"id": 2, "name": "Jane Smith", "email": "jane@example.com", "created_at": "2024-01-02T11:00:00Z"},
    {"id": 3, "name": "Bob Johnson", "email": "bob@example.com", "created_at": "2024-01-03T12:00:00Z"}
]

@app.route('/')
def index():
    """Root endpoint - API information with server identification"""
    return jsonify({
        "message": "Nginx Load Balancer Backend API",
        "version": "1.0.0",
        "server_info": {
            "server_id": SERVER_ID,
            "hostname": HOSTNAME,
            "port": PORT,
            "timestamp": datetime.now().isoformat()
        },
        "endpoints": {
            "GET /": "API information",
            "GET /health": "Health check",
            "GET /server-info": "Server information",
            "GET /users": "Get all users",
            "GET /users/<id>": "Get user by ID",
            "POST /users": "Create new user",
            "PUT /users/<id>": "Update user",
            "DELETE /users/<id>": "Delete user"
        }
    })

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "service": f"backend-api-{SERVER_ID}",
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "timestamp": datetime.now().isoformat()
    })

@app.route('/server-info')
def server_info():
    """Get detailed server information"""
    return jsonify({
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "port": PORT,
        "python_version": os.sys.version,
        "flask_version": "2.3.0",
        "uptime": "running",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/users', methods=['GET'])
def get_users():
    """Get all users"""
    return jsonify({
        "users": users,
        "count": len(users),
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "timestamp": datetime.now().isoformat()
    })

@app.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Get user by ID"""
    user = next((u for u in users if u["id"] == user_id), None)
    if user:
        return jsonify({
            "user": user,
            "server_id": SERVER_ID,
            "hostname": HOSTNAME,
            "timestamp": datetime.now().isoformat()
        })
    else:
        return jsonify({
            "error": "User not found",
            "message": f"No user found with ID {user_id}",
            "server_id": SERVER_ID,
            "hostname": HOSTNAME
        }), 404

@app.route('/users', methods=['POST'])
def create_user():
    """Create a new user"""
    try:
        data = request.get_json()
        
        if not data or 'name' not in data or 'email' not in data:
            return jsonify({
                "error": "Invalid data",
                "message": "Name and email are required",
                "server_id": SERVER_ID,
                "hostname": HOSTNAME
            }), 400
        
        # Check if email already exists
        if any(u["email"] == data["email"] for u in users):
            return jsonify({
                "error": "Email already exists",
                "message": f"User with email {data['email']} already exists",
                "server_id": SERVER_ID,
                "hostname": HOSTNAME
            }), 409
        
        # Create new user
        new_id = max(u["id"] for u in users) + 1 if users else 1
        new_user = {
            "id": new_id,
            "name": data["name"],
            "email": data["email"],
            "created_at": datetime.now().isoformat()
        }
        
        users.append(new_user)
        
        return jsonify({
            "message": "User created successfully",
            "user": new_user,
            "server_id": SERVER_ID,
            "hostname": HOSTNAME,
            "timestamp": datetime.now().isoformat()
        }), 201
        
    except Exception as e:
        return jsonify({
            "error": "Server error",
            "message": str(e),
            "server_id": SERVER_ID,
            "hostname": HOSTNAME
        }), 500

@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """Update user by ID"""
    try:
        user = next((u for u in users if u["id"] == user_id), None)
        if not user:
            return jsonify({
                "error": "User not found",
                "message": f"No user found with ID {user_id}",
                "server_id": SERVER_ID,
                "hostname": HOSTNAME
            }), 404
        
        data = request.get_json()
        if not data:
            return jsonify({
                "error": "Invalid data",
                "message": "No data provided for update",
                "server_id": SERVER_ID,
                "hostname": HOSTNAME
            }), 400
        
        # Update user fields
        if 'name' in data:
            user["name"] = data["name"]
        if 'email' in data:
            # Check if email already exists for other users
            if any(u["email"] == data["email"] and u["id"] != user_id for u in users):
                return jsonify({
                    "error": "Email already exists",
                    "message": f"User with email {data['email']} already exists",
                    "server_id": SERVER_ID,
                    "hostname": HOSTNAME
                }), 409
            user["email"] = data["email"]
        
        return jsonify({
            "message": "User updated successfully",
            "user": user,
            "server_id": SERVER_ID,
            "hostname": HOSTNAME,
            "timestamp": datetime.now().isoformat()
        })
        
    except Exception as e:
        return jsonify({
            "error": "Server error",
            "message": str(e),
            "server_id": SERVER_ID,
            "hostname": HOSTNAME
        }), 500

@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete user by ID"""
    user = next((u for u in users if u["id"] == user_id), None)
    if not user:
        return jsonify({
            "error": "User not found",
            "message": f"No user found with ID {user_id}",
            "server_id": SERVER_ID,
            "hostname": HOSTNAME
        }), 404
    
    users.remove(user)
    
    return jsonify({
        "message": "User deleted successfully",
        "deleted_user": user,
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "timestamp": datetime.now().isoformat()
    })

@app.route('/stats')
def stats():
    """Get API statistics"""
    return jsonify({
        "total_users": len(users),
        "server_info": {
            "server_id": SERVER_ID,
            "hostname": HOSTNAME,
            "port": PORT,
            "python_version": os.sys.version,
            "flask_version": "2.3.0"
        },
        "timestamp": datetime.now().isoformat()
    })

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        "error": "Not found",
        "message": "The requested resource was not found",
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "timestamp": datetime.now().isoformat()
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({
        "error": "Internal server error",
        "message": "An unexpected error occurred",
        "server_id": SERVER_ID,
        "hostname": HOSTNAME,
        "timestamp": datetime.now().isoformat()
    }), 500

if __name__ == '__main__':
    print(f"Starting Nginx Load Balancer Backend API {SERVER_ID} on port {PORT}")
    print(f"Hostname: {HOSTNAME}")
    print("Available endpoints:")
    print("  GET  /           - API information")
    print("  GET  /health     - Health check")
    print("  GET  /server-info - Server information")
    print("  GET  /users      - Get all users")
    print("  POST /users      - Create new user")
    print("  GET  /stats      - API statistics")
    
    # Run the Flask app
    app.run(
        host='0.0.0.0',
        port=PORT,
        debug=False,
        threaded=True
    )
