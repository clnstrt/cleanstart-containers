#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# Test configuration
BASE_URL = 'http://localhost:4567'

def test_health_check
  puts "Testing health check..."
  begin
    response = Net::HTTP.get_response(URI("#{BASE_URL}/health"))
    if response.code == '200'
      data = JSON.parse(response.body)
      puts "✓ Health check passed: #{data['status']}"
      return true
    else
      puts "✗ Health check failed: #{response.code}"
      return false
    end
  rescue => e
    puts "✗ Health check error: #{e.message}"
    return false
  end
end

def test_api_endpoints
  puts "\nTesting API endpoints..."
  
  # Test creating a user
  puts "Creating test user..."
  uri = URI("#{BASE_URL}/api/users")
  http = Net::HTTP.new(uri.host, uri.port)
  
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = {
    name: 'Test User',
    email: 'test@example.com'
  }.to_json
  
  response = http.request(request)
  if response.code == '201'
    user_data = JSON.parse(response.body)
    user_id = user_data['id']
    puts "✓ User created with ID: #{user_id}"
    
    # Test getting all users
    puts "Getting all users..."
    response = Net::HTTP.get_response(URI("#{BASE_URL}/api/users"))
    if response.code == '200'
      users = JSON.parse(response.body)
      puts "✓ Retrieved #{users.length} users"
    else
      puts "✗ Failed to get users: #{response.code}"
    end
    
    # Test getting specific user
    puts "Getting user #{user_id}..."
    response = Net::HTTP.get_response(URI("#{BASE_URL}/api/users/#{user_id}"))
    if response.code == '200'
      user = JSON.parse(response.body)
      puts "✓ Retrieved user: #{user['name']} (#{user['email']})"
    else
      puts "✗ Failed to get user: #{response.code}"
    end
    
    # Test deleting user
    puts "Deleting user #{user_id}..."
    request = Net::HTTP::Delete.new(URI("#{BASE_URL}/api/users/#{user_id}"))
    response = http.request(request)
    if response.code == '200'
      puts "✓ User deleted successfully"
    else
      puts "✗ Failed to delete user: #{response.code}"
    end
    
  else
    puts "✗ Failed to create user: #{response.code}"
  end
end

def main
  puts "Ruby Sinatra Application Test"
  puts "=" * 30
  
  # Test if server is running
  unless test_health_check
    puts "\nMake sure the application is running with: ruby app.rb"
    exit 1
  end
  
  # Test API endpoints
  test_api_endpoints
  
  puts "\n✓ All tests completed!"
end

if __FILE__ == $0
  main
end
