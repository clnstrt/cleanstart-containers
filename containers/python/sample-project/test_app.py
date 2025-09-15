#!/usr/bin/env python3
"""
Simple test script to verify the CRUD application setup.
"""

import os
import sys
import requests
import time
import subprocess
from threading import Thread

def test_database():
    """Test database operations."""
    print("Testing database operations...")
    
    try:
        from models.database import init_db, reset_db
        from models.user import User
        
        # Reset database for clean test
        reset_db()
        
        # Test creating a user
        user = User(name="Test User", email="test@example.com", age=25)
        user.save()
        print("✓ User creation successful")
        
        # Test retrieving user
        retrieved_user = User.get_by_id(user.id)
        assert retrieved_user is not None
        assert retrieved_user.name == "Test User"
        print("✓ User retrieval successful")
        
        # Test updating user
        user.name = "Updated User"
        user.update()
        updated_user = User.get_by_id(user.id)
        assert updated_user.name == "Updated User"
        print("✓ User update successful")
        
        # Test deleting user
        user.delete()
        deleted_user = User.get_by_id(user.id)
        assert deleted_user is None
        print("✓ User deletion successful")
        
        print("✓ All database tests passed!")
        return True
        
    except Exception as e:
        print(f"✗ Database test failed: {e}")
        return False

def test_web_interface():
    """Test web interface endpoints."""
    print("Testing web interface...")
    
    base_url = "http://localhost:5000"
    
    try:
        # Test health endpoint
        response = requests.get(f"{base_url}/health", timeout=5)
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"
        print("✓ Health check successful")
        
        # Test home page
        response = requests.get(f"{base_url}/", timeout=5)
        assert response.status_code == 200
        print("✓ Home page accessible")
        
        # Test API endpoints
        response = requests.get(f"{base_url}/users", timeout=5)
        assert response.status_code == 200
        print("✓ Users API endpoint accessible")
        
        print("✓ All web interface tests passed!")
        return True
        
    except requests.exceptions.ConnectionError:
        print("✗ Web interface not accessible (app may not be running)")
        return False
    except Exception as e:
        print(f"✗ Web interface test failed: {e}")
        return False

def start_app():
    """Start the Flask app in a separate thread."""
    try:
        import app
        app.app.run(host='0.0.0.0', port=5000, debug=False)
    except Exception as e:
        print(f"Failed to start app: {e}")

def main():
    """Run all tests."""
    print("=" * 50)
    print("CRUD Sample Application Test Suite")
    print("=" * 50)
    
    # Test database operations
    db_success = test_database()
    
    # Start app in background for web tests
    print("\nStarting Flask app for web interface tests...")
    app_thread = Thread(target=start_app, daemon=True)
    app_thread.start()
    
    # Wait for app to start
    time.sleep(3)
    
    # Test web interface
    web_success = test_web_interface()
    
    # Summary
    print("\n" + "=" * 50)
    print("Test Results Summary:")
    print("=" * 50)
    print(f"Database Tests: {'PASSED' if db_success else 'FAILED'}")
    print(f"Web Interface Tests: {'PASSED' if web_success else 'FAILED'}")
    
    if db_success and web_success:
        print("\n🎉 All tests passed! The application is working correctly.")
        print("\nYou can now:")
        print("1. Visit http://localhost:5000 to use the web interface")
        print("2. Use the API endpoints for programmatic access")
        print("3. Build and run the Docker container")
    else:
        print("\n❌ Some tests failed. Please check the error messages above.")
        sys.exit(1)

if __name__ == "__main__":
    main()
