#!/usr/bin/env python3
"""
Memcached Hello World Example
This demonstrates basic Memcached operations using Python
"""

import memcache
import time
import json

def main():
    # Connect to Memcached server
    mc = memcache.Client(['localhost:11211'])
    
    print("🚀 Memcached Hello World Example")
    print("=" * 40)
    
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
    
    print("\n✅ Memcached Hello World completed successfully!")

if __name__ == "__main__":
    main()
