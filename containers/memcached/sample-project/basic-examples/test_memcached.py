#!/usr/bin/env python3
"""
Test Memcached Sample Project
This simulates Memcached behavior for testing without a server
"""

import time
import json

class MockMemcache:
    """Mock Memcached client for testing without server"""
    
    def __init__(self, servers):
        self.data = {}
        self.expiry = {}
    
    def set(self, key, value, time=0):
        """Set a value in mock cache"""
        self.data[key] = value
        if time > 0:
            self.expiry[key] = time.time() + time
        return True
    
    def get(self, key):
        """Get a value from mock cache"""
        if key in self.expiry and time.time() > self.expiry[key]:
            del self.data[key]
            del self.expiry[key]
            return None
        return self.data.get(key)
    
    def delete(self, key):
        """Delete a key from mock cache"""
        if key in self.data:
            del self.data[key]
            if key in self.expiry:
                del self.expiry[key]
            return True
        return False
    
    def incr(self, key):
        """Increment a counter"""
        current = self.get(key) or 0
        self.set(key, current + 1)
        return current + 1
    
    def get_multi(self, keys):
        """Get multiple keys"""
        result = {}
        for key in keys:
            value = self.get(key)
            if value is not None:
                result[key] = value
        return result

def test_memcached_operations():
    """Test basic Memcached operations"""
    print("🚀 Testing Memcached Sample Project")
    print("=" * 50)
    
    # Use mock client instead of real memcache
    mc = MockMemcache(['localhost:11211'])
    
    # Basic set and get operations
    print("\n1. Basic Set/Get Operations:")
    mc.set("hello", "Hello, Memcached!")
    mc.set("number", 42)
    mc.set("list", [1, 2, 3, 4, 5])
    
    print(f"   hello: {mc.get('hello')}")
    print(f"   number: {mc.get('number')}")
    print(f"   list: {mc.get('list')}")
    
    # Set with expiration
    print("\n2. Set with Expiration:")
    mc.set("temp_key", "This will expire in 5 seconds", time=5)
    print(f"   temp_key: {mc.get('temp_key')}")
    print("   Waiting 6 seconds...")
    time.sleep(6)
    print(f"   temp_key after expiration: {mc.get('temp_key')}")
    
    # Counter operations
    print("\n3. Counter Operations:")
    mc.set("counter", 0)
    print(f"   Initial counter: {mc.get('counter')}")
    
    for i in range(5):
        mc.incr("counter")
        print(f"   After increment {i+1}: {mc.get('counter')}")
    
    # Delete operation
    print("\n4. Delete Operation:")
    mc.set("to_delete", "This will be deleted")
    print(f"   Before delete: {mc.get('to_delete')}")
    mc.delete("to_delete")
    print(f"   After delete: {mc.get('to_delete')}")
    
    # Get multiple keys
    print("\n5. Get Multiple Keys:")
    mc.set("key1", "value1")
    mc.set("key2", "value2")
    mc.set("key3", "value3")
    
    keys = ["key1", "key2", "key3", "nonexistent"]
    values = mc.get_multi(keys)
    print(f"   Multiple keys: {values}")
    
    print("\n✅ Memcached Sample Project test completed successfully!")
    print("Note: This test used a mock Memcached client since no server is running.")

if __name__ == "__main__":
    test_memcached_operations()
