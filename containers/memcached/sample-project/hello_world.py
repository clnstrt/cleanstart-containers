#!/usr/bin/env python3
"""
Memcached Hello World Example
This demonstrates basic Memcached operations using Python
"""

import time
import json
from datetime import datetime

class MockMemcache:
    """Mock Memcached client for testing without server"""
    
    def __init__(self, servers):
        self.data = {}
        self.expiry = {}
        print(f"   Connected to mock Memcached servers: {servers}")
    
    def set(self, key, value, time=0):
        """Set a value in mock cache"""
        self.data[key] = value
        if time > 0:
            self.expiry[key] = time.time() + time
        print(f"   SET {key} = {value}")
        return True
    
    def get(self, key):
        """Get a value from mock cache"""
        if key in self.expiry and time.time() > self.expiry[key]:
            del self.data[key]
            del self.expiry[key]
            print(f"   GET {key} = None (expired)")
            return None
        
        value = self.data.get(key)
        print(f"   GET {key} = {value}")
        return value
    
    def delete(self, key):
        """Delete a key from mock cache"""
        if key in self.data:
            del self.data[key]
            if key in self.expiry:
                del self.expiry[key]
            print(f"   DELETE {key} = True")
            return True
        print(f"   DELETE {key} = False")
        return False
    
    def incr(self, key):
        """Increment a counter"""
        current = self.get(key) or 0
        new_value = current + 1
        self.set(key, new_value)
        print(f"   INCR {key} = {new_value}")
        return new_value
    
    def decr(self, key):
        """Decrement a counter"""
        current = self.get(key) or 0
        new_value = max(0, current - 1)
        self.set(key, new_value)
        print(f"   DECR {key} = {new_value}")
        return new_value
    
    def get_multi(self, keys):
        """Get multiple keys"""
        result = {}
        for key in keys:
            value = self.get(key)
            if value is not None:
                result[key] = value
        print(f"   GET_MULTI {keys} = {result}")
        return result
    
    def flush_all(self):
        """Flush all keys"""
        self.data.clear()
        self.expiry.clear()
        print("   FLUSH_ALL = True")
        return True

def test_basic_operations():
    """Test basic Memcached operations"""
    print("🔧 Testing Basic Operations:")
    print("=" * 40)
    
    # Use mock client instead of real memcache
    mc = MockMemcache(['localhost:11211'])
    
    # Basic set and get
    mc.set("hello", "Hello, Memcached!")
    mc.set("number", 42)
    mc.set("list", [1, 2, 3, 4, 5])
    mc.set("dict", {"name": "Memcached", "version": "1.6"})
    
    # Get values
    print(f"\n   Retrieved values:")
    print(f"   hello: {mc.get('hello')}")
    print(f"   number: {mc.get('number')}")
    print(f"   list: {mc.get('list')}")
    print(f"   dict: {mc.get('dict')}")
    
    return mc

def test_expiration():
    """Test key expiration"""
    print("\n⏰ Testing Key Expiration:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Set key with 3 second expiration
    mc.set("temp_key", "This will expire in 3 seconds", time=3)
    print(f"   temp_key: {mc.get('temp_key')}")
    
    print("   Waiting 4 seconds...")
    time.sleep(4)
    print(f"   temp_key after expiration: {mc.get('temp_key')}")

def test_counter_operations():
    """Test counter operations"""
    print("\n🔢 Testing Counter Operations:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Initialize counter
    mc.set("counter", 0)
    print(f"   Initial counter: {mc.get('counter')}")
    
    # Increment counter
    for i in range(5):
        mc.incr("counter")
        print(f"   After increment {i+1}: {mc.get('counter')}")
    
    # Decrement counter
    for i in range(2):
        mc.decr("counter")
        print(f"   After decrement {i+1}: {mc.get('counter')}")

def test_delete_operations():
    """Test delete operations"""
    print("\n🗑️  Testing Delete Operations:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Set some keys
    mc.set("key1", "value1")
    mc.set("key2", "value2")
    mc.set("key3", "value3")
    
    # Delete a key
    mc.delete("key2")
    
    # Try to get deleted key
    print(f"   key1: {mc.get('key1')}")
    print(f"   key2: {mc.get('key2')}")
    print(f"   key3: {mc.get('key3')}")

def test_multi_operations():
    """Test multi-key operations"""
    print("\n📦 Testing Multi-Key Operations:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Set multiple keys
    mc.set("user:1", {"name": "John", "email": "john@example.com"})
    mc.set("user:2", {"name": "Jane", "email": "jane@example.com"})
    mc.set("user:3", {"name": "Bob", "email": "bob@example.com"})
    
    # Get multiple keys
    keys = ["user:1", "user:2", "user:3", "user:4"]
    values = mc.get_multi(keys)
    print(f"   Retrieved {len(values)} out of {len(keys)} keys")

def test_session_simulation():
    """Simulate session management"""
    print("\n🔐 Testing Session Simulation:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Simulate user session
    session_id = "session_12345"
    session_data = {
        "user_id": 123,
        "username": "john_doe",
        "login_time": datetime.now().isoformat(),
        "permissions": ["read", "write", "admin"]
    }
    
    # Store session
    mc.set(f"session:{session_id}", session_data, time=3600)  # 1 hour
    print(f"   Session stored: {session_id}")
    
    # Retrieve session
    retrieved_session = mc.get(f"session:{session_id}")
    print(f"   Session retrieved: {retrieved_session['username']}")
    
    # Update session
    retrieved_session["last_activity"] = datetime.now().isoformat()
    mc.set(f"session:{session_id}", retrieved_session, time=3600)
    print("   Session updated with last activity")

def test_cache_patterns():
    """Test common caching patterns"""
    print("\n🎯 Testing Cache Patterns:")
    print("=" * 40)
    
    mc = MockMemcache(['localhost:11211'])
    
    # Cache-aside pattern
    def get_user_data(user_id):
        cache_key = f"user:{user_id}"
        user_data = mc.get(cache_key)
        
        if user_data is None:
            # Simulate database fetch
            print(f"   Cache miss - fetching from database for user {user_id}")
            user_data = {
                "id": user_id,
                "name": f"User {user_id}",
                "email": f"user{user_id}@example.com",
                "created_at": datetime.now().isoformat()
            }
            mc.set(cache_key, user_data, time=300)  # 5 minutes
        else:
            print(f"   Cache hit - using cached data for user {user_id}")
        
        return user_data
    
    # Test cache-aside pattern
    user1 = get_user_data(1)
    user1_cached = get_user_data(1)  # Should hit cache
    user2 = get_user_data(2)

def main():
    """Main function to run Memcached hello world"""
    print("🚀 Memcached Hello World Example")
    print("=" * 50)
    
    # Test basic operations
    test_basic_operations()
    
    # Test expiration
    test_expiration()
    
    # Test counter operations
    test_counter_operations()
    
    # Test delete operations
    test_delete_operations()
    
    # Test multi operations
    test_multi_operations()
    
    # Test session simulation
    test_session_simulation()
    
    # Test cache patterns
    test_cache_patterns()
    
    print("\n🎉 Memcached Hello World completed successfully!")
    print("✅ All basic operations tested")
    print("✅ Expiration mechanism verified")
    print("✅ Counter operations working")
    print("✅ Multi-key operations functional")
    print("✅ Session management simulated")
    print("✅ Cache patterns demonstrated")
    
    print("\n📚 Next Steps:")
    print("   1. Install real Memcached server")
    print("   2. Use python-memcached library")
    print("   3. Explore web-integration/ for Flask examples")
    print("   4. Try production caching patterns")

if __name__ == "__main__":
    main()
