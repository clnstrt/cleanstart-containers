#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sqlite3'
require 'json'
require 'time'

# Configuration
set :port, ENV['PORT'] || 4567
set :bind, '0.0.0.0'
set :database, 'users.db'

# Database setup
def get_db
  db = SQLite3::Database.new(settings.database)
  db.results_as_hash = true
  db
end

def init_db
  db = get_db
  db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  SQL
  db.close
end

# Initialize database on startup
init_db

# Routes
get '/' do
  db = get_db
  @users = db.execute('SELECT * FROM users ORDER BY created_at DESC')
  db.close
  erb :index
end

get '/add' do
  erb :add_user
end

post '/add' do
  name = params['name']&.strip
  email = params['email']&.strip
  
  if name.nil? || name.empty? || email.nil? || email.empty?
    @error = 'Name and email are required!'
    return erb :add_user
  end
  
  db = get_db
  begin
    db.execute('INSERT INTO users (name, email) VALUES (?, ?)', [name, email])
    db.close
    redirect '/'
  rescue SQLite3::ConstraintException
    db.close
    @error = 'Email already exists!'
    erb :add_user
  end
end

post '/delete/:id' do
  id = params['id']
  db = get_db
  db.execute('DELETE FROM users WHERE id = ?', [id])
  db.close
  redirect '/'
end

post '/reset' do
  db = get_db
  db.execute('DELETE FROM users')
  db.close
  redirect '/'
end

# API endpoints
get '/api/users' do
  content_type :json
  db = get_db
  users = db.execute('SELECT * FROM users ORDER BY created_at DESC')
  db.close
  
  users.map do |user|
    {
      id: user['id'],
      name: user['name'],
      email: user['email'],
      created_at: user['created_at']
    }
  end.to_json
end

post '/api/users' do
  content_type :json
  data = JSON.parse(request.body.read)
  
  name = data['name']&.strip
  email = data['email']&.strip
  
  if name.nil? || name.empty? || email.nil? || email.empty?
    status 400
    return { error: 'Name and email are required' }.to_json
  end
  
  db = get_db
  begin
    db.execute('INSERT INTO users (name, email) VALUES (?, ?)', [name, email])
    user_id = db.last_insert_row_id
    user = db.execute('SELECT * FROM users WHERE id = ?', [user_id]).first
    db.close
    
    status 201
    {
      id: user['id'],
      name: user['name'],
      email: user['email'],
      created_at: user['created_at']
    }.to_json
  rescue SQLite3::ConstraintException
    db.close
    status 400
    { error: 'Email already exists' }.to_json
  end
end

get '/api/users/:id' do
  content_type :json
  id = params['id']
  
  db = get_db
  user = db.execute('SELECT * FROM users WHERE id = ?', [id]).first
  db.close
  
  if user.nil?
    status 404
    return { error: 'User not found' }.to_json
  end
  
  {
    id: user['id'],
    name: user['name'],
    email: user['email'],
    created_at: user['created_at']
  }.to_json
end

delete '/api/users/:id' do
  content_type :json
  id = params['id']
  
  db = get_db
  user = db.execute('SELECT * FROM users WHERE id = ?', [id]).first
  
  if user.nil?
    db.close
    status 404
    return { error: 'User not found' }.to_json
  end
  
  db.execute('DELETE FROM users WHERE id = ?', [id])
  db.close
  
  { message: 'User deleted successfully' }.to_json
end

get '/health' do
  content_type :json
  {
    status: 'healthy',
    timestamp: Time.now.iso8601
  }.to_json
end

# Error handlers
not_found do
  content_type :json
  { error: 'Not found' }.to_json
end

error do
  content_type :json
  { error: 'Internal server error' }.to_json
end
