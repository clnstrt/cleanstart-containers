// package main

// import (
// 	"database/sql"
// 	"log"
// 	"net/http"
// 	"os"
// 	"strconv"
// 	"fmt"
// 	"github.com/gin-gonic/gin"
// 	_ "modernc.org/sqlite"
// )

// // User represents a user in the database
// type User struct {
// 	ID    int    `json:"id"`
// 	Name  string `json:"name"`
// 	Email string `json:"email"`
// }

// // Database represents the database connection
// type Database struct {
// 	db *sql.DB
// }

// // NewDatabase creates a new database connection
// // func NewDatabase() (*Database, error) {
// // 	// Remove existing database file if it exists
// // 	os.Remove("users.db")

// 	// Open database connection
// 	db, err := sql.Open("sqlite", "users.db")
// 	if err != nil {
// 		return nil, err
// 	}

// 	// Create users table
// 	createTableSQL := `
// 	CREATE TABLE users (
// 		id INTEGER PRIMARY KEY AUTOINCREMENT,
// 		name TEXT NOT NULL,
// 		email TEXT NOT NULL UNIQUE
// 	)`

// 	_, err = db.Exec(createTableSQL)
// 	if err != nil {
// 		return nil, err
// 	}

// 	log.Println("Database created successfully")
// 	log.Println("Table created successfully")

// 	return &Database{db: db}, nil


// // InsertUser inserts a new user into the database
// func (d *Database) InsertUser(name, email string) error {
// 	insertSQL := "INSERT INTO users (name, email) VALUES (?, ?)"
// 	_, err := d.db.Exec(insertSQL, name, email)
// 	if err != nil {
// 		return err
// 	}
// 	log.Println("User inserted successfully")
// 	return nil
// }

// // GetAllUsers retrieves all users from the database
// func (d *Database) GetAllUsers() ([]User, error) {
// 	rows, err := d.db.Query("SELECT id, name, email FROM users")
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer rows.Close()

// 	var users []User
// 	for rows.Next() {
// 		var user User
// 		err := rows.Scan(&user.ID, &user.Name, &user.Email)
// 		if err != nil {
// 			return nil, err
// 		}
// 		users = append(users, user)
// 	}
// 	return users, nil
// }

// // GetUserByID retrieves a user by ID
// func (d *Database) GetUserByID(id int) (*User, error) {
// 	var user User
// 	err := d.db.QueryRow("SELECT id, name, email FROM users WHERE id = ?", id).Scan(&user.ID, &user.Name, &user.Email)
// 	if err != nil {
// 		return nil, err
// 	}
// 	return &user, nil
// }

// // UpdateUser updates a user in the database
// func (d *Database) UpdateUser(id int, name, email string) error {
// 	updateSQL := "UPDATE users SET name = ?, email = ? WHERE id = ?"
// 	_, err := d.db.Exec(updateSQL, name, email, id)
// 	return err
// }

// // DeleteUser deletes a user from the database
// func (d *Database) DeleteUser(id int) error {
// 	deleteSQL := "DELETE FROM users WHERE id = ?"
// 	_, err := d.db.Exec(deleteSQL, id)
// 	return err
// }

// // Close closes the database connection
// func (d *Database) Close() error {
// 	return d.db.Close()
// }

// func main() {
// 	// Create database
// 	database, err := NewDatabase()
// 	if err != nil {
// 		log.Fatal("Failed to create database:", err)
// 	}
// 	defer database.Close()

// 	// Insert sample users
// 	err = database.InsertUser("John Doe", "john@example.com")
// 	if err != nil {
// 		log.Printf("Failed to insert user: %v", err)
// 	}

// 	err = database.InsertUser("Ankur Raval", "ankur@mail.com")
// 	if err != nil {
// 		log.Printf("Failed to insert user: %v", err)
// 	}

// 	err = database.InsertUser("Sunny Shah", "bob@example.com")
// 	if err != nil {
// 		log.Printf("Failed to insert user: %v", err)
// 	}

// 	err = database.InsertUser("Pratham Shah", "pratham@example.com")
// 	if err != nil {
// 		log.Printf("Failed to insert user: %v", err)
// 	}

// 	// Display all users
// 	users, err := database.GetAllUsers()
// 	if err != nil {
// 		log.Printf("Failed to get users: %v", err)
// 	} else {
// 		log.Println("All users:")
// 		for _, user := range users {
// 			log.Printf("ID: %d, Name: %s, Email: %s", user.ID, user.Name, user.Email)
// 		}
// 	}

// 	// Set up Gin router
// 	gin.SetMode(gin.ReleaseMode)
// 	r := gin.Default()

// 	// Load HTML templates
// 	r.LoadHTMLGlob("templates/*")
	
// 	// Add debug route to test template loading
// 	r.GET("/test", func(c *gin.Context) {
// 		c.HTML(http.StatusOK, "index.html", gin.H{
// 			"users": []User{
// 				{ID: 1, Name: "Test User", Email: "test@example.com"},
// 			},
// 		})
// 	})

// 	// Serve static files
// 	r.Static("/static", "./static")

// 	// Routes
// 	r.GET("/", func(c *gin.Context) {
// 		log.Println("Received request for /")
// 		users, err := database.GetAllUsers()
// 		if err != nil {
// 			log.Printf("Error getting users: %v", err)
// 			c.HTML(http.StatusInternalServerError, "error.html", gin.H{
// 				"error": "Failed to load users",
// 			})
// 			return
// 		}
// 		log.Printf("Found %d users", len(users))
// 		c.HTML(http.StatusOK, "index.html", gin.H{
// 			"users": users,
// 		})
// 	})

// 	r.GET("/add", func(c *gin.Context) {
// 		c.HTML(http.StatusOK, "add_user.html", gin.H{})
// 	})

// 	r.POST("/add", func(c *gin.Context) {
// 		name := c.PostForm("name")
// 		email := c.PostForm("email")
// 		if name == "" || email == "" {
// 			c.HTML(http.StatusBadRequest, "add_user.html", gin.H{
// 				"error": "Name and email are required",
// 			})
// 			return
// 		}

// 		err := database.InsertUser(name, email);
// 		fmt.Println("There is error! Please check the code"); 
// 		fmt.Println(err); 
// 		if err != nil {
// 			c.HTML(http.StatusInternalServerError, "add_user.html", gin.H{
// 				"error": "Failed to add user: " + err.Error(),
// 			})
// 			return
// 		}
// 		c.Redirect(http.StatusSeeOther, "/")	
// 	})

// 	r.GET("/edit/:id", func(c *gin.Context) {
// 		idStr := c.Param("id")
// 		id, err := strconv.Atoi(idStr)
// 		if err != nil {
// 			c.HTML(http.StatusBadRequest, "error.html", gin.H{
// 				"error": "Invalid user ID",
// 			})
// 			return
// 		}

// 		user, err := database.GetUserByID(id)
// 		if err != nil {
// 			c.HTML(http.StatusNotFound, "error.html", gin.H{
// 				"error": "User not found",
// 			})
// 			return
// 		}

// 		c.HTML(http.StatusOK, "edit_user.html", gin.H{
// 			"user": user,
// 		})
// 	})

// 	r.POST("/edit/:id", func(c *gin.Context) {
// 		idStr := c.Param("id")
// 		id, err := strconv.Atoi(idStr)
// 		if err != nil {
// 			c.HTML(http.StatusBadRequest, "error.html", gin.H{
// 				"error": "Invalid user ID",
// 			})
// 			return
// 		}

// 		name := c.PostForm("name")
// 		email := c.PostForm("email")

// 		if name == "" || email == "" {
// 			c.HTML(http.StatusBadRequest, "edit_user.html", gin.H{
// 				"error": "Name and email are required",
// 				"user":  &User{ID: id, Name: name, Email: email},
// 			})
// 			return
// 		}

// 		err = database.UpdateUser(id, name, email)
// 		if err != nil {
// 			c.HTML(http.StatusInternalServerError, "edit_user.html", gin.H{
// 				"error": "Failed to update user: " + err.Error(),
// 				"user":  &User{ID: id, Name: name, Email: email},
// 			})
// 			return
// 		}

// 		c.Redirect(http.StatusSeeOther, "/")
// 	})

// 	r.POST("/delete/:id", func(c *gin.Context) {
// 		idStr := c.Param("id")
// 		id, err := strconv.Atoi(idStr)
// 		if err != nil {
// 			c.HTML(http.StatusBadRequest, "error.html", gin.H{
// 				"error": "Invalid user ID",
// 			})
// 			return
// 		}

// 		err = database.DeleteUser(id)
// 		if err != nil {
// 			c.HTML(http.StatusInternalServerError, "error.html", gin.H{
// 				"error": "Failed to delete user: " + err.Error(),
// 			})
// 			return
// 		}

// 		c.Redirect(http.StatusSeeOther, "/")
// 	})

// 	// API endpoints
// 	r.GET("/api/users", func(c *gin.Context) {
// 		users, err := database.GetAllUsers()
// 		if err != nil {
// 			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
// 			return
// 		}
// 		c.JSON(http.StatusOK, users)
// 	})

// 	r.POST("/api/users", func(c *gin.Context) {
// 		var user User
// 		if err := c.ShouldBindJSON(&user); err != nil {
// 			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
// 			return
// 		}

// 		err := database.InsertUser(user.Name, user.Email)
// 		if err != nil {
// 			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
// 			return
// 		}

// 		c.JSON(http.StatusCreated, gin.H{"message": "User created successfully"})
// 	})

// 	// Start server
// 	log.Println("Starting Go web server on http://0.0.0.0:8080")
// 	log.Fatal(r.Run("0.0.0.0:8080"))
// }





package main

import (
	"database/sql"   // Standard SQL package to interact with databases
	"fmt"            // For formatted I/O (e.g., fmt.Println)
	"log"            // Logging messages to terminal
	"net/http"       // For HTTP status codes           // For file system operations (checking DB file existence)
	"strconv"        // Convert strings to integers
	"github.com/gin-gonic/gin" // Gin web framework
	_ "modernc.org/sqlite"     // SQLite driver for database/sql
)


// ---------------------------
// Model: User
// ---------------------------
// This struct represents a row in the `users` table.
// The `json` tags are used when sending/receiving JSON (for API endpoints).
type User struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Email string `json:"email"`
}


// ---------------------------
// Database Wrapper
// ---------------------------
// Holds the actual *sql.DB object so we can attach methods for queries.
type Database struct {
	db *sql.DB
}


// ---------------------------
// NewDatabase()
// ---------------------------
// Opens (or creates) a SQLite database file called `users.db`.
// Also creates the `users` table if it does not already exist.
func NewDatabase() (*Database, error) {
	// Open SQLite database file (it will be created if it doesn’t exist)
	db, err := sql.Open("sqlite", "users.db")
	if err != nil {
		return nil, err
	}

	// Create table if not exists (so it’s safe to restart app)
	createTableSQL := `
	CREATE TABLE IF NOT EXISTS users (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		email TEXT NOT NULL UNIQUE
	)`

	_, err = db.Exec(createTableSQL)
	if err != nil {
		return nil, err
	}

	log.Println("✅ Database connected and users table ready")
	return &Database{db: db}, nil
}


// ---------------------------
// InsertUser()
// ---------------------------
// Inserts a new user row into the database.
func (d *Database) InsertUser(name, email string) error {
	insertSQL := "INSERT INTO users (name, email) VALUES (?, ?)"
	_, err := d.db.Exec(insertSQL, name, email)
	if err != nil {
		return err
	}
	log.Printf("User inserted successfully: %s (%s)\n", name, email)
	return nil
}


// ---------------------------
// GetAllUsers()
// ---------------------------
// Reads all users from the DB and returns as a slice.
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


// ---------------------------
// GetUserByID()
// ---------------------------
// Fetches a single user from DB by ID.
func (d *Database) GetUserByID(id int) (*User, error) {
	var user User
	err := d.db.QueryRow("SELECT id, name, email FROM users WHERE id = ?", id).
		Scan(&user.ID, &user.Name, &user.Email)

	if err != nil {
		return nil, err
	}
	return &user, nil
}


// ---------------------------
// UpdateUser()
// ---------------------------
// Updates a user’s name + email by ID.
func (d *Database) UpdateUser(id int, name, email string) error {
	updateSQL := "UPDATE users SET name = ?, email = ? WHERE id = ?"
	_, err := d.db.Exec(updateSQL, name, email, id)
	if err == nil {
		log.Printf(" User updated successfully: ID=%d → %s (%s)\n", id, name, email)
	}
	return err
}


// ---------------------------
// DeleteUser()
// ---------------------------
// Deletes a user row by ID.
func (d *Database) DeleteUser(id int) error {
	deleteSQL := "DELETE FROM users WHERE id = ?"
	_, err := d.db.Exec(deleteSQL, id)
	if err == nil {
		log.Printf("🗑️ User deleted successfully: ID=%d\n", id)
	}
	return err
}


// ---------------------------
// Close()
// ---------------------------
// Gracefully closes DB connection.
func (d *Database) Close() error {
	return d.db.Close()
}


// main()
// Entry point of the application
func main() {
	// 1️⃣ Connect to database
	database, err := NewDatabase()
	if err != nil {
		log.Fatal("❌ Failed to create database:", err)
	}
	defer database.Close()

	// 2️⃣ Insert some demo users (only if DB is empty)
	users, _ := database.GetAllUsers()
	if len(users) == 0 {
		log.Println("Inserting sample users...")
		database.InsertUser("John Doe", "john@example.com")
		database.InsertUser("Ankur Raval", "ankur@mail.com")
		database.InsertUser("Sunny Shah", "sunny@example.com")
		database.InsertUser("Pratham Shah", "pratham@example.com")
	}
	log.Printf("%+v", users)
	// 3️⃣ Setup Gin router
	gin.SetMode(gin.ReleaseMode) // Run Gin in release mode (quieter logs)
	r := gin.Default()

	// Load HTML templates from ./templates folder
	r.LoadHTMLGlob("templates/*")

	// Serve static files (CSS, JS, images) from ./static folder
	r.Static("/static", "./static")


	// Web Routes (HTML pages)

	// Homepage -> show all users
	r.GET("/", func(c *gin.Context) {
		users, err := database.GetAllUsers()
		if err != nil {
			c.HTML(http.StatusInternalServerError, "error.html", gin.H{"error": "Failed to load users"})
			return
		}
		c.HTML(http.StatusOK, "index.html", gin.H{"users": users})
	})

	// Show "Add User" form
	r.GET("/add", func(c *gin.Context) {
		c.HTML(http.StatusOK, "add_user.html", nil)
	})

	// Handle "Add User" form submission
	r.POST("/add", func(c *gin.Context) {
		name := c.PostForm("name")
		email := c.PostForm("email")

		if name == "" || email == "" {
			c.HTML(http.StatusBadRequest, "add_user.html", gin.H{"error": "Name and email are required"})
			return
		}

		err := database.InsertUser(name, email)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "add_user.html", gin.H{"error": "Failed to add user: " + err.Error()})
			return
		}
		c.Redirect(http.StatusSeeOther, "/")
	})

	// Show "Edit User" form
	r.GET("/edit/:id", func(c *gin.Context) {
		id, err := strconv.Atoi(c.Param("id"))
		if err != nil {
			c.HTML(http.StatusBadRequest, "error.html", gin.H{"error": "Invalid user ID"})
			return
		}
		user, err := database.GetUserByID(id)
		if err != nil {
			c.HTML(http.StatusNotFound, "error.html", gin.H{"error": "User not found"})
			return
		}
		c.HTML(http.StatusOK, "edit_user.html", gin.H{"user": user})
	})

	// Handle "Edit User" form submission
	r.POST("/edit/:id", func(c *gin.Context) {
		id, _ := strconv.Atoi(c.Param("id"))
		name := c.PostForm("name")
		email := c.PostForm("email")

		if name == "" || email == "" {
			c.HTML(http.StatusBadRequest, "edit_user.html", gin.H{
				"error": "Name and email are required",
				"user":  &User{ID: id, Name: name, Email: email},
			})
			return
		}

		err := database.UpdateUser(id, name, email)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "edit_user.html", gin.H{
				"error": "Failed to update user: " + err.Error(),
				"user":  &User{ID: id, Name: name, Email: email},
			})
			return
		}
		c.Redirect(http.StatusSeeOther, "/")
	})

	// Handle Delete user
	r.POST("/delete/:id", func(c *gin.Context) {
		id, _ := strconv.Atoi(c.Param("id"))
		err := database.DeleteUser(id)
		if err != nil {
			c.HTML(http.StatusInternalServerError, "error.html", gin.H{"error": "Failed to delete user"})
			return
		}
		c.Redirect(http.StatusSeeOther, "/")
	})

	
	// REST API Routes (JSON API)

	// Get all users as JSON
	r.GET("/api/users", func(c *gin.Context) {
		users, err := database.GetAllUsers()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, users)
	})

	// Add new user via JSON
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

	// Start HTTP server
	log.Println("Starting Go web server on http://0.0.0.0:8080")
	log.Fatal(r.Run("0.0.0.0:8080"))
}






