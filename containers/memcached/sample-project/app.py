#!/usr/bin/env python3
"""
Memcached Demo Application
A Flask app demonstrating various caching patterns with Memcached
"""

from flask import flask, jsonify, request, render_template_string
import time
import json
import hashlib
from pymemcache.client import base
from pymemcache import serde
from datetime import datetime
import sys
from colorama import init, Fore, Style

# Initialize colorama for colored console output
init()

app = Flask(__name__)

# Memcached configuration
MEMCACHED_HOST = 'localhost'
MEMCACHED_PORT = 11211

# Initialize Memcached client with error handling
try:
    memcache_client = base.Client(
        (MEMCACHED_HOST, MEMCACHED_PORT),
        serde=serde.pickle_serde,
        connect_timeout=2,
        timeout=2
    )
    # Test connection
    memcache_client.stats()
    print(f"{Fore.GREEN}✓ Connected to Memcached at {MEMCACHED_HOST}:{MEMCACHED_PORT}{Style.RESET_ALL}")
except Exception as e:
    print(f"{Fore.RED}✗ Failed to connect to Memcached: {e}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}Make sure Memcached container is running:{Style.RESET_ALL}")
    print(f"  docker run -d --name memcached-demo -p 11211:11211 cleanstart/memcached:latest-dev")
    sys.exit(1)

# HTML template for the home page
HOME_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>Memcached Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; border-bottom: 3px solid #4CAF50; padding-bottom: 10px; }
        .endpoint { background: #f9f9f9; padding: 15px; margin: 15px 0; border-left: 4px solid #4CAF50; border-radius: 5px; }
        .endpoint h3 { margin-top: 0; color: #4CAF50; }
        .endpoint code { background: #272822; color: #f8f8f2; padding: 3px 8px; border-radius: 3px; font-family: 'Courier New', monospace; }
        .test-btn { background: #4CAF50; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px; }
        .test-btn:hover { background: #45a049; }
        .stats { background: #e8f5e9; padding: 15px; border-radius: 5px; margin-top: 20px; }
        pre { background: #272822; color: #f8f8f2; padding: 15px; border-radius: 5px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Memcached Demo Application</h1>
        <p>Test various caching patterns with your Memcached Docker container</p>
        
        <div class="stats">
            <h3>📊 Quick Stats</h3>
            <p>Memcached Server: <strong>{{ host }}:{{ port }}</strong></p>
            <p>Status: <strong style="color: green;">Connected</strong></p>
        </div>
        
        <h2>Available Endpoints</h2>
        
        <div class="endpoint">
            <h3>Fibonacci Calculator</h3>
            <p>Calculates and caches Fibonacci numbers</p>
            <code>GET /fibonacci/&lt;number&gt;</code>
            <br><br>
            <button class="test-btn" onclick="testEndpoint('/fibonacci/35')">Test n=35</button>
            <button class="test-btn" onclick="testEndpoint('/fibonacci/40')">Test n=40</button>
        </div>
        
        <div class="endpoint">
            <h3>User Data API</h3>
            <p>Simulates database queries with 60-second cache TTL</p>
            <code>GET /user/&lt;user_id&gt;</code>
            <br><br>
            <button class="test-btn" onclick="testEndpoint('/user/123')">Get User 123</button>
            <button class="test-btn" onclick="testEndpoint('/user/456')">Get User 456</button>
        </div>
        
        <div class="endpoint">
            <h3>Slow Query Simulation</h3>
            <p>Demonstrates performance improvement with caching (2-second query)</p>
            <code>GET /slow-query?param=value</code>
            <br><br>
            <button class="test-btn" onclick="testEndpoint('/slow-query?type=report')">Test Query</button>
        </div>
        
        <div class="endpoint">
            <h3>Cache Management</h3>
            <p>View statistics and manage cache</p>
            <code>GET /cache/stats</code> - View cache statistics<br>
            <code>POST /cache/flush</code> - Clear all cache<br>
            <code>GET /cache/keys</code> - List cached keys<br><br>
            <button class="test-btn" onclick="testEndpoint('/cache/stats')">View Stats</button>
            <button class="test-btn" onclick="testEndpoint('/cache/keys')">List Keys</button>
            <button class="test-btn" onclick="flushCache()">Flush Cache</button>
        </div>
        
        <h2>Response</h2>
        <pre id="response">Click a test button to see the response here...</pre>
    </div>
    
    <script>
        async function testEndpoint(url) {
            const responseDiv = document.getElementById('response');
            responseDiv.textContent = 'Loading...';
            
            const start = performance.now();
            try {
                const response = await fetch(url);
                const data = await response.json();
                const end = performance.now();
                
                responseDiv.textContent = JSON.stringify(data, null, 2) + 
                    '\\n\\nResponse Time: ' + (end - start).toFixed(2) + 'ms';
            } catch (error) {
                responseDiv.textContent = 'Error: ' + error.message;
            }
        }
        
        async function flushCache() {
            const responseDiv = document.getElementById('response');
            responseDiv.textContent = 'Flushing cache...';
            
            try {
                const response = await fetch('/cache/flush', { method: 'POST' });
                const data = await response.json();
                responseDiv.textContent = JSON.stringify(data, null, 2);
            } catch (error) {
                responseDiv.textContent = 'Error: ' + error.message;
            }
        }
    </script>
</body>
</html>
"""

# Track cached keys for demonstration
cached_keys = set()

def track_key(key):
    """Track keys that we cache"""
    cached_keys.add(key)

@app.route('/')
def index():
    """Home page with interactive UI"""
    return render_template_string(HOME_PAGE, host=MEMCACHED_HOST, port=MEMCACHED_PORT)

@app.route('/fibonacci/<int:n>')
def fibonacci(n):
    """Calculate Fibonacci number with caching"""
    if n < 0 or n > 100:
        return jsonify({"error": "Please provide a number between 0 and 100"}), 400
    
    cache_key = f"fib:{n}"
    
    # Try to get from cache
    cached_result = memcache_client.get(cache_key)
    if cached_result is not None:
        return jsonify({
            "number": n,
            "result": cached_result,
            "cached": True,
            "cache_key": cache_key,
            "message": "Retrieved from cache instantly!"
        })
    
    # Calculate Fibonacci
    start_time = time.time()
    
    def calculate_fib(n):
        if n <= 1:
            return n
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b
    
    result = calculate_fib(n)
    calculation_time = time.time() - start_time
    
    # Store in cache
    memcache_client.set(cache_key, result)
    track_key(cache_key)
    
    return jsonify({
        "number": n,
        "result": result,
        "cached": False,
        "calculation_time": f"{calculation_time:.4f} seconds",
        "cache_key": cache_key,
        "message": "Calculated and cached for future requests"
    })

@app.route('/user/<int:user_id>')
def get_user(user_id):
    """Simulate fetching user data with 60-second cache"""
    cache_key = f"user:{user_id}"
    
    # Try to get from cache
    cached_data = memcache_client.get(cache_key)
    if cached_data is not None:
        cached_data['cached'] = True
        cached_data['message'] = "Retrieved from cache"
        return jsonify(cached_data)
    
    # Simulate database fetch
    time.sleep(0.5)  # Simulate slow database query
    
    user_data = {
        "id": user_id,
        "username": f"user_{user_id}",
        "email": f"user{user_id}@example.com",
        "full_name": f"User Number {user_id}",
        "last_login": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "account_type": "premium" if user_id % 2 == 0 else "standard",
        "cached": False,
        "cache_ttl": "60 seconds",
        "message": "Fetched from database (slow) and cached for 60 seconds"
    }
    
    # Store in cache with 60 second expiration
    memcache_client.set(cache_key, user_data, expire=60)
    track_key(cache_key)
    
    return jsonify(user_data)

@app.route('/slow-query')
def slow_query():
    """Simulate a slow database query with caching"""
    query_params = dict(request.args)
    cache_key = f"query:{json.dumps(query_params, sort_keys=True)}"
    
    # Try to get from cache
    cached_result = memcache_client.get(cache_key)
    if cached_result is not None:
        return jsonify({
            "data": cached_result,
            "cached": True,
            "response_time": "instant",
            "cache_key": cache_key,
            "message": "Served from cache - no waiting!"
        })
    
    # Simulate slow operation
    start_time = time.time()
    time.sleep(2)  # Simulate 2-second database query
    
    result = {
        "query_params": query_params,
        "timestamp": time.time(),
        "data": "Result of expensive database query",
        "rows_processed": 10000,
        "items": [f"Item {i}" for i in range(1, 11)]
    }
    
    response_time = time.time() - start_time
    
    # Cache for 5 minutes
    memcache_client.set(cache_key, result, expire=300)
    track_key(cache_key)
    
    return jsonify({
        "data": result,
        "cached": False,
        "response_time": f"{response_time:.2f} seconds",
        "cache_key": cache_key,
        "cache_ttl": "5 minutes",
        "message": "Slow query executed and cached for 5 minutes"
    })

@app.route('/cache/stats')
def cache_stats():
    """Get Memcached statistics"""
    try:
        stats = memcache_client.stats()
        
        # Convert byte values to strings
        stats_dict = {}
        for key, value in stats.items():
            if isinstance(key, bytes):
                key = key.decode('utf-8')
            if isinstance(value, bytes):
                value = value.decode('utf-8')
            stats_dict[key] = value
        
        # Extract interesting stats
        return jsonify({
            "status": "connected",
            "host": f"{MEMCACHED_HOST}:{MEMCACHED_PORT}",
            "uptime": f"{int(stats_dict.get('uptime', 0)) // 60} minutes",
            "version": stats_dict.get('version', 'unknown'),
            "current_items": stats_dict.get('curr_items', '0'),
            "total_items_stored": stats_dict.get('total_items', '0'),
            "cache_hits": stats_dict.get('get_hits', '0'),
            "cache_misses": stats_dict.get('get_misses', '0'),
            "memory_used": f"{int(stats_dict.get('bytes', 0)) / 1024:.2f} KB",
            "max_memory": f"{int(stats_dict.get('limit_maxbytes', 0)) / (1024*1024):.0f} MB",
            "tracked_keys": list(cached_keys)
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

@app.route('/cache/keys')
def list_keys():
    """List all tracked cache keys"""
    return jsonify({
        "keys": list(cached_keys),
        "count": len(cached_keys),
        "note": "These are keys cached by this application session"
    })

@app.route('/cache/flush', methods=['POST'])
def flush_cache():
    """Clear all cache entries"""
    try:
        memcache_client.flush_all()
        cached_keys.clear()
        return jsonify({
            "status": "success",
            "message": "All cache entries have been cleared"
        })
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == '__main__':
    print(f"{Fore.CYAN}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}Memcached Demo Application{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.GREEN}➜{Style.RESET_ALL} Open your browser at: {Fore.YELLOW}http://localhost:5000{Style.RESET_ALL}")
    print(f"{Fore.GREEN}➜{Style.RESET_ALL} Press {Fore.RED}Ctrl+C{Style.RESET_ALL} to stop the server")
    print(f"{Fore.CYAN}{'='*60}{Style.RESET_ALL}\n")
    
    app.run(host='0.0.0.0', port=5000, debug=True)