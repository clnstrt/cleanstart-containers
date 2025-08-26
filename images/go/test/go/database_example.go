package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	_ "github.com/mattn/go-sqlite3"
)

// User represents a user in the database
type User struct {
	ID    int
	Name  string
	Email string
}

// Database represents the database connection
type Database struct {
	db *sql.DB
}

// NewDatabase creates a new database connection
func NewDatabase() (*Database, error) {
	// Remove existing database file if it exists
	os.Remove("users.db")

	// Open database connection
	db, err := sql.Open("sqlite3", "users.db")
	if err != nil {
		return nil, err
	}

	// Create users table
	createTableSQL := `
	CREATE TABLE users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		email TEXT NOT NULL UNIQUE
	)`

	_, err = db.Exec(createTableSQL)
	if err != nil {
		return nil, err
	}

	fmt.Println("Database created successfully")
	fmt.Println("Table created successfully")

	return &Database{db: db}, nil
}

// InsertUser inserts a new user into the database
func (d *Database) InsertUser(name, email string) error {
	insertSQL := "INSERT INTO users (name, email) VALUES (?, ?)"
	_, err := d.db.Exec(insertSQL, name, email)
	if err != nil {
		return err
	}
	fmt.Println("User inserted successfully")
	return nil
}

// GetAllUsers retrieves all users from the database
func (d *Database) GetAllUsers() ([]User, error) {
	rows, err := d.db.Query("SELECT id, name, email FROM users")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []User
	for rows.Next() {
		var user User
		err := rows.Scan(&user.ID, &user.Name, &user.Email)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}
	return users, nil
}

// DisplayUsers displays all users in a formatted way
func DisplayUsers(users []User) {
	fmt.Println("All users:")
	for _, user := range users {
		fmt.Printf("ID: %d, Name: %s, Email: %s\n", user.ID, user.Name, user.Email)
	}
}

// Close closes the database connection
func (d *Database) Close() error {
	return d.db.Close()
}

func main() {
	fmt.Println("Go SQLite Database Example")
	fmt.Println("==========================")

	// Create database
	database, err := NewDatabase()
	if err != nil {
		log.Fatal("Failed to create database:", err)
	}
	defer database.Close()

	// Insert sample users
	err = database.InsertUser("John Doe", "john@example.com")
	if err != nil {
		log.Printf("Failed to insert user: %v", err)
	}

	err = database.InsertUser("Jane Smith", "jane@example.com")
	if err != nil {
		log.Printf("Failed to insert user: %v", err)
	}

	err = database.InsertUser("Bob Johnson", "bob@example.com")
	if err != nil {
		log.Printf("Failed to insert user: %v", err)
	}

	// Query and display all users
	users, err := database.GetAllUsers()
	if err != nil {
		log.Printf("Failed to get users: %v", err)
	} else {
		DisplayUsers(users)
	}

	// Close database connection
	database.Close()
	fmt.Println("Database connection closed")
}
