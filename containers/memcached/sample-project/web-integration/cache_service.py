#!/usr/bin/env python3
"""
Memcached Web Integration Example
A service that demonstrates how to use Memcached for caching in web applications
"""

import memcache
import time
import json
from functools import wraps

class CacheService:
    """A service class for handling Memcached operations"""
    
    def __init__(self, servers=['localhost:11211']):
        self.mc = memcache.Client(servers)
        self.default_ttl = 300  # 5 minutes default TTL
    
    def get(self, key):
        """Get a value from cache"""
        return self.mc.get(key)
    
    def set(self, key, value, ttl=None):
        """Set a value in cache"""
        if ttl is None:
            ttl = self.default_ttl
        return self.mc.set(key, value, time=ttl)
    
    def delete(self, key):
        """Delete a key from cache"""
        return self.mc.delete(key)
    
    def get_or_set(self, key, func, ttl=None):
        """Get value from cache or set it using a function"""
        value = self.get(key)
        if value is None:
            value = func()
            self.set(key, value, ttl)
        return value

def cache_result(ttl=300):
    """Decorator to cache function results"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # Create cache key from function name and arguments
            cache_key = f"{func.__name__}:{hash(str(args) + str(kwargs))}"
            
            # Try to get from cache
            cached_result = cache_service.get(cache_key)
            if cached_result is not None:
                print(f"Cache hit for {cache_key}")
                return cached_result
            
            # Execute function and cache result
            print(f"Cache miss for {cache_key}")
            result = func(*args, **kwargs)
            cache_service.set(cache_key, result, ttl)
            return result
        return wrapper
    return decorator

# Initialize cache service
cache_service = CacheService()

# Example functions that benefit from caching
@cache_result(ttl=60)
def expensive_database_query(user_id):
    """Simulate an expensive database query"""
    print(f"Executing expensive query for user {user_id}")
    time.sleep(2)  # Simulate database delay
    return {
        'user_id': user_id,
        'name': f'User {user_id}',
        'email': f'user{user_id}@example.com',
        'last_login': '2024-01-15 10:30:00'
    }

@cache_result(ttl=300)
def get_weather_data(city):
    """Simulate weather API call"""
    print(f"Fetching weather data for {city}")
    time.sleep(1)  # Simulate API delay
    return {
        'city': city,
        'temperature': 22,
        'humidity': 65,
        'description': 'Partly cloudy'
    }

def main():
    """Demonstrate cache service usage"""
    print("🚀 Memcached Web Integration Example")
    print("=" * 50)
    
    # Test expensive database query caching
    print("\n1. Testing Database Query Caching:")
    start_time = time.time()
    result1 = expensive_database_query(123)
    print(f"   First call took: {time.time() - start_time:.2f}s")
    print(f"   Result: {result1}")
    
    start_time = time.time()
    result2 = expensive_database_query(123)
    print(f"   Second call took: {time.time() - start_time:.2f}s")
    print(f"   Result: {result2}")
    
    # Test weather data caching
    print("\n2. Testing Weather Data Caching:")
    start_time = time.time()
    weather1 = get_weather_data("New York")
    print(f"   First call took: {time.time() - start_time:.2f}s")
    print(f"   Weather: {weather1}")
    
    start_time = time.time()
    weather2 = get_weather_data("New York")
    print(f"   Second call took: {time.time() - start_time:.2f}s")
    print(f"   Weather: {weather2}")
    
    # Test manual cache operations
    print("\n3. Testing Manual Cache Operations:")
    cache_service.set("session:user123", {"user_id": 123, "login_time": time.time()})
    session_data = cache_service.get("session:user123")
    print(f"   Session data: {session_data}")
    
    # Test cache with different TTL
    cache_service.set("temp_data", "This expires quickly", ttl=5)
    print(f"   Temp data: {cache_service.get('temp_data')}")
    print("   Waiting 6 seconds...")
    time.sleep(6)
    print(f"   Temp data after expiration: {cache_service.get('temp_data')}")
    
    print("\n✅ Memcached Web Integration completed successfully!")

if __name__ == "__main__":
    main()
