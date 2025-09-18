#!/usr/bin/env python3
"""
Test script for Memcached functionality
Run this to verify your Memcached container is working properly
"""

import time
import sys
from pymemcache.client import base
from pymemcache import serde
from colorama import init, Fore, Style
from tabulate import tabulate

# Initialize colorama
init()

def print_header(text):
    print(f"\n{Fore.CYAN}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{text}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{'='*60}{Style.RESET_ALL}\n")

def print_success(text):
    print(f"{Fore.GREEN}✓ {text}{Style.RESET_ALL}")

def print_error(text):
    print(f"{Fore.RED}✗ {text}{Style.RESET_ALL}")

def print_info(text):
    print(f"{Fore.YELLOW}ℹ {text}{Style.RESET_ALL}")

def test_memcached():
    """Test Memcached operations"""
    
    print_header("Testing Memcached Container")
    
    # Connect to Memcached
    try:
        print("Connecting to Memcached...")
        client = base.Client(
            ('localhost', 11211),
            serde=serde.pickle_serde,
            connect_timeout=2,
            timeout=2
        )
        
        # Test connection
        stats = client.stats()
        print_success("Connected to Memcached successfully!")
        
    except Exception as e:
        print_error(f"Failed to connect: {e}")
        print_info("Make sure the container is running:")
        print("  docker run -d --name memcached-demo -p 11211:11211 cleanstart/memcached:latest-dev")
        return False
    
    # Run tests
    tests_passed = 0
    tests_failed = 0
    results = []
    
    print_header("Running Tests")
    
    # Test 1: Set and Get
    try:
        print("Test 1: Basic Set/Get...")
        client.set('test_key', 'Hello, Memcached!')
        result = client.get('test_key')
        assert result == 'Hello, Memcached!'
        print_success("Basic Set/Get works!")
        tests_passed += 1
        results.append(['Set/Get', 'PASSED', 'Basic operations work'])
    except Exception as e:
        print_error(f"Basic Set/Get failed: {e}")
        tests_failed += 1
        results.append(['Set/Get', 'FAILED', str(e)])
    
    # Test 2: Expiration
    try:
        print("\nTest 2: Expiration (TTL)...")
        client.set('temp_key', 'temporary', expire=2)
        assert client.get('temp_key') == 'temporary'
        print("  Value set with 2-second TTL")
        time.sleep(3)
        assert client.get('temp_key') is None
        print_success("TTL expiration works!")
        tests_passed += 1
        results.append(['TTL/Expiration', 'PASSED', 'Keys expire correctly'])
    except Exception as e:
        print_error(f"TTL test failed: {e}")
        tests_failed += 1
        results.append(['TTL/Expiration', 'FAILED', str(e)])
    
    # Test 3: Delete
    try:
        print("\nTest 3: Delete operation...")
        client.set('delete_me', 'value')
        client.delete('delete_me')
        assert client.get('delete_me') is None
        print_success("Delete operation works!")
        tests_passed += 1
        results.append(['Delete', 'PASSED', 'Keys can be deleted'])
    except Exception as e:
        print_error(f"Delete test failed: {e}")
        tests_failed += 1
        results.append(['Delete', 'FAILED', str(e)])
    
    # Test 4: Complex data types
    try:
        print("\nTest 4: Complex data types...")
        complex_data = {
            'list': [1, 2, 3, 4, 5],
            'dict': {'name': 'test', 'value': 42},
            'tuple': (1, 'two', 3.0)
        }
        client.set('complex', complex_data)
        result = client.get('complex')
        assert result == complex_data
        print_success("Complex data types work!")
        tests_passed += 1
        results.append(['Complex Types', 'PASSED', 'Lists, dicts, tuples supported'])
    except Exception as e:
        print_error(f"Complex types test failed: {e}")
        tests_failed += 1
        results.append(['Complex Types', 'FAILED', str(e)])
    
    # Test 5: Large value
    try:
        print("\nTest 5: Large values...")
        large_value = 'x' * 100000  # 100KB string
        client.set('large', large_value)
        result = client.get('large')
        assert result == large_value
        print_success("Large values work!")
        tests_passed += 1
        results.append(['Large Values', 'PASSED', '100KB values supported'])
    except Exception as e:
        print_error(f"Large value test failed: {e}")
        tests_failed += 1
        results.append(['Large Values', 'FAILED', str(e)])
    
    # Test 6: Flush
    try:
        print("\nTest 6: Flush all...")
        client.set('before_flush', 'value')
        client.flush_all()
        assert client.get('before_flush') is None
        print_success("Flush all works!")
        tests_passed += 1
        results.append(['Flush All', 'PASSED', 'Cache can be cleared'])
    except Exception as e:
        print_error(f"Flush test failed: {e}")
        tests_failed += 1
        results.append(['Flush All', 'FAILED', str(e)])
    
    # Display results
    print_header("Test Results Summary")
    
    # Show table
    print(tabulate(results, headers=['Test', 'Status', 'Details'], tablefmt='grid'))
    
    # Summary
    print(f"\n{Fore.CYAN}Total Tests: {tests_passed + tests_failed}{Style.RESET_ALL}")
    print(f"{Fore.GREEN}Passed: {tests_passed}{Style.RESET_ALL}")
    print(f"{Fore.RED}Failed: {tests_failed}{Style.RESET_ALL}")
    
    # Server stats
    print_header("Memcached Server Stats")
    stats = client.stats()
    stats_table = []
    for key, value in stats.items():
        if isinstance(key, bytes):
            key = key.decode('utf-8')
        if isinstance(value, bytes):
            value = value.decode('utf-8')
        
        if key in ['version', 'uptime', 'curr_items', 'total_items', 'bytes', 'limit_maxbytes']:
            if key == 'uptime':
                value = f"{int(value) // 60} minutes"
            elif key == 'bytes':
                value = f"{int(value) / 1024:.2f} KB"
            elif key == 'limit_maxbytes':
                value = f"{int(value) / (1024*1024):.0f} MB"
            stats_table.append([key, value])
    
    print(tabulate(stats_table, headers=['Stat', 'Value'], tablefmt='simple'))
    
    return tests_passed > 0

if __name__ == '__main__':
    success = test_memcached()
    sys.exit(0 if success else 1)