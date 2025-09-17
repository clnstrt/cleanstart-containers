#!/usr/bin/env python3
"""
Integration tests for the Flask User Management Application
Tests the application in a more realistic environment.
"""

import requests
import time
import subprocess
import signal
import os
import tempfile
import json
from threading import Thread


class FlaskAppTester:
    """Test the Flask application by running it and making HTTP requests."""
    
    def __init__(self):
        self.app_process = None
        self.base_url = "http://localhost:5000"
        self.test_db = None
    
    def start_app(self):
        """Start the Flask application in a separate process."""
        print("🚀 Starting Flask application...")
        
        # Create temporary database file
        self.test_db = tempfile.NamedTemporaryFile(delete=False)
        self.test_db.close()
        
        # Set environment variables
        env = os.environ.copy()
        env['DATABASE'] = self.test_db.name
        env['FLASK_ENV'] = 'testing'
        
        # Start the application
        self.app_process = subprocess.Popen(
            ['python', 'app.py'],
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        
        # Wait for the app to start
        time.sleep(3)
        
        # Check if the process is still running
        if self.app_process.poll() is not None:
            stdout, stderr = self.app_process.communicate()
            print(f"❌ Failed to start app. Error: {stderr.decode()}")
            return False
        
        print("✅ Flask application started successfully")
        return True
    
    def stop_app(self):
        """Stop the Flask application."""
        if self.app_process:
            print("🛑 Stopping Flask application...")
            self.app_process.terminate()
            self.app_process.wait()
            print("✅ Flask application stopped")
        
        # Clean up test database
        if self.test_db and os.path.exists(self.test_db.name):
            os.unlink(self.test_db.name)
    
    def test_health_endpoint(self):
        """Test the health check endpoint."""
        print("🔍 Testing health endpoint...")
        try:
            response = requests.get(f"{self.base_url}/health", timeout=5)
            assert response.status_code == 200
            data = response.json()
            assert data['status'] == 'healthy'
            assert 'timestamp' in data
            print("✅ Health endpoint working")
            return True
        except Exception as e:
            print(f"❌ Health endpoint failed: {e}")
            return False
    
    def test_index_page(self):
        """Test the index page."""
        print("🔍 Testing index page...")
        try:
            response = requests.get(f"{self.base_url}/", timeout=5)
            assert response.status_code == 200
            print("✅ Index page working")
            return True
        except Exception as e:
            print(f"❌ Index page failed: {e}")
            return False
    
    def test_add_user_page(self):
        """Test the add user page."""
        print("🔍 Testing add user page...")
        try:
            response = requests.get(f"{self.base_url}/add", timeout=5)
            assert response.status_code == 200
            print("✅ Add user page working")
            return True
        except Exception as e:
            print(f"❌ Add user page failed: {e}")
            return False
    
    def test_user_crud_operations(self):
        """Test complete user CRUD operations."""
        print("🔍 Testing user CRUD operations...")
        
        try:
            # Create a user via API
            user_data = {
                'name': 'Integration Test User',
                'email': 'integration@test.com'
            }
            
            response = requests.post(
                f"{self.base_url}/api/users",
                json=user_data,
                timeout=5
            )
            assert response.status_code == 201
            created_user = response.json()
            user_id = created_user['id']
            print("✅ User creation via API working")
            
            # Get the user
            response = requests.get(f"{self.base_url}/api/users/{user_id}", timeout=5)
            assert response.status_code == 200
            retrieved_user = response.json()
            assert retrieved_user['name'] == user_data['name']
            assert retrieved_user['email'] == user_data['email']
            print("✅ User retrieval working")
            
            # Get all users
            response = requests.get(f"{self.base_url}/api/users", timeout=5)
            assert response.status_code == 200
            users = response.json()
            assert len(users) >= 1
            print("✅ Get all users working")
            
            # Delete the user
            response = requests.delete(f"{self.base_url}/api/users/{user_id}", timeout=5)
            assert response.status_code == 200
            print("✅ User deletion working")
            
            # Verify user is deleted
            response = requests.get(f"{self.base_url}/api/users/{user_id}", timeout=5)
            assert response.status_code == 404
            print("✅ User deletion verification working")
            
            return True
            
        except Exception as e:
            print(f"❌ User CRUD operations failed: {e}")
            return False
    
    def test_form_submission(self):
        """Test form submission."""
        print("🔍 Testing form submission...")
        try:
            form_data = {
                'name': 'Form Test User',
                'email': 'form@test.com'
            }
            
            response = requests.post(
                f"{self.base_url}/add",
                data=form_data,
                timeout=5,
                allow_redirects=True
            )
            assert response.status_code == 200
            print("✅ Form submission working")
            return True
            
        except Exception as e:
            print(f"❌ Form submission failed: {e}")
            return False
    
    def run_all_tests(self):
        """Run all integration tests."""
        print("🧪 Starting Integration Tests")
        print("=" * 50)
        
        if not self.start_app():
            return False
        
        try:
            tests = [
                self.test_health_endpoint,
                self.test_index_page,
                self.test_add_user_page,
                self.test_user_crud_operations,
                self.test_form_submission
            ]
            
            passed = 0
            total = len(tests)
            
            for test in tests:
                if test():
                    passed += 1
                print()  # Add spacing between tests
            
            print("=" * 50)
            print(f"📊 Integration Test Results: {passed}/{total} tests passed")
            
            if passed == total:
                print("🎉 All integration tests passed!")
                return True
            else:
                print("❌ Some integration tests failed!")
                return False
                
        finally:
            self.stop_app()


def main():
    """Main function to run integration tests."""
    tester = FlaskAppTester()
    
    try:
        success = tester.run_all_tests()
        exit_code = 0 if success else 1
    except KeyboardInterrupt:
        print("\n🛑 Tests interrupted by user")
        tester.stop_app()
        exit_code = 1
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        tester.stop_app()
        exit_code = 1
    
    return exit_code


if __name__ == "__main__":
    exit_code = main()
    exit(exit_code)
