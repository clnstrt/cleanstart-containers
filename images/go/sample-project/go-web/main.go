package main

import (
	"database/sql"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/gin-gonic/gin"
	_ "modernc.org/sqlite"
)

// User represents a user in the database
type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
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
	db, err := sql.Open("sqlite", "users.db")
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

	log.Println("Database created successfully")
	log.Println("Table created successfully")

	return &Database{db: db}, nil
}

// InsertUser inserts a new user into the database
func (d *Database) InsertUser(name, email string) error {
	insertSQL := "INSERT INTO users (name, email) VALUES (?, ?)"
	_, err := d.db.Exec(insertSQL, name, email)
	if err != nil {
		return err
	}
	log.Println("User inserted successfully")
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

// GetUserByID retrieves a user by ID
func (d *Database) GetUserByID(id int) (*User, error) {
	var user User
	err := d.db.QueryRow("SELECT id, name, email FROM users WHERE id = ?", id).Scan(&user.ID, &user.Name, &user.Email)
	if err != nil {
		return nil, err
	}
	return &user, nil
}

// UpdateUser updates a user in the database
func (d *Database) UpdateUser(id int, name, email string) error {
	updateSQL := "UPDATE users SET name = ?, email = ? WHERE id = ?"
	_, err := d.db.Exec(updateSQL, name, email, id)
	return err
}

// DeleteUser deletes a user from the database
func (d *Database) DeleteUser(id int) error {
	deleteSQL := "DELETE FROM users WHERE id = ?"
	_, err := d.db.Exec(deleteSQL, id)
	return err
}

// Close closes the database connection
func (d *Database) Close() error {
	return d.db.Close()
}

func main() {
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

	// Display all users
	users, err := database.GetAllUsers()
	if err != nil {
		log.Printf("Failed to get users: %v", err)
	} else {
		log.Println("All users:")
		for _, user := range users {
			log.Printf("ID: %d, Name: %s, Email: %s", user.ID, user.Name, user.Email)
		}
	}

	// Set up Gin router
	gin.SetMode(gin.ReleaseMode)
	r := gin.Default()

	// Load HTML templates
	r.LoadHTMLGlob("templates/*")
	
	// Add debug route to test template loading
	r.GET("/test", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.html", gin.H{
			"users": []User{
				{ID: 1, Name: "Test User", Email: "test@example.com"},
			},
		})
	})

	// Serve static files
	r.Static("/static", "./static")

	// Routes
	r.GET("/", func(c *gin.Context) {
		log.Println("Received request for /")
		users, err := database.GetAllUsers()
		if err != nil {
			log.Printf("Error getting users: %v", err)
			c.HTML(http.StatusInternalServerError, "error.html", gin.H{
				"error": "Failed to load users",
			})
			return
		}
		log.Printf("Found %d users", len(users))
		c.HTML(http.StatusOK, "index.html", gin.H{
			"users": users,
		})
	})

	r.GET("/add", func(c *gin.Context) {
		c.HTML(http.StatusOK, "add_user.html", gin.H{})
	})

	r.POST("/add", func(c *gin.Context) {
		name := c.PostForm("name")
		email := c.PostForm("email")

		if name == "" || email == "" {
			c.HTML(http.StatusBadRequest, "add_user.html", gin.H{
				"error": "Name and email are required",
			})
			return
		}

		err := database.InsertUser(name, email)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "add_user.html", gin.H{
				"error": "Failed to add user: " + err.Error(),
			})
			return
		}

		c.Redirect(http.StatusSeeOther, "/")
	})

	r.GET("/edit/:id", func(c *gin.Context) {
		idStr := c.Param("id")
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.HTML(http.StatusBadRequest, "error.html", gin.H{
				"error": "Invalid user ID",
			})
			return
		}

		user, err := database.GetUserByID(id)
		if err != nil {
			c.HTML(http.StatusNotFound, "error.html", gin.H{
				"error": "User not found",
			})
			return
		}

		c.HTML(http.StatusOK, "edit_user.html", gin.H{
			"user": user,
		})
	})

	r.POST("/edit/:id", func(c *gin.Context) {
		idStr := c.Param("id")
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.HTML(http.StatusBadRequest, "error.html", gin.H{
				"error": "Invalid user ID",
			})
			return
		}

		name := c.PostForm("name")
		email := c.PostForm("email")

		if name == "" || email == "" {
			c.HTML(http.StatusBadRequest, "edit_user.html", gin.H{
				"error": "Name and email are required",
				"user":  &User{ID: id, Name: name, Email: email},
			})
			return
		}

		err = database.UpdateUser(id, name, email)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "edit_user.html", gin.H{
				"error": "Failed to update user: " + err.Error(),
				"user":  &User{ID: id, Name: name, Email: email},
			})
			return
		}

		c.Redirect(http.StatusSeeOther, "/")
	})

	r.POST("/delete/:id", func(c *gin.Context) {
		idStr := c.Param("id")
		id, err := strconv.Atoi(idStr)
		if err != nil {
			c.HTML(http.StatusBadRequest, "error.html", gin.H{
				"error": "Invalid user ID",
			})
			return
		}

		err = database.DeleteUser(id)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "error.html", gin.H{
				"error": "Failed to delete user: " + err.Error(),
			})
			return
		}

		c.Redirect(http.StatusSeeOther, "/")
	})

	// API endpoints
	r.GET("/api/users", func(c *gin.Context) {
		users, err := database.GetAllUsers()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, users)
	})

	r.POST("/api/users", func(c *gin.Context) {
		var user User
		if err := c.ShouldBindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		err := database.InsertUser(user.Name, user.Email)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
	})

	// Start server
	log.Println("Starting Go web server on http://0.0.0.0:8080")
	log.Fatal(r.Run("0.0.0.0:8080"))
}
