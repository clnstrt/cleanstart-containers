# Go SQLite Database Example

## Overview
This example demonstrates basic SQLite database operations using Go's `database/sql` package and the `github.com/mattn/go-sqlite3` driver.

## 🚀 Quick Start - Run Locally

### Prerequisites
- **Go 1.21 or higher**
- **GCC compiler** (for SQLite CGO)
- No additional dependencies required

### Step 1: Navigate to Go Directory
```bash
cd containers/app4/test/go
```

### Step 2: Run the Example
```bash
# Download dependencies
go mod tidy

# Run the program
go run database_example.go
```

### Step 3: View Results
The program will output database operations and display all users.

## 🔧 Detailed Setup Instructions

### Check Go Installation
```bash
# Verify Go is installed
go version

# Should show something like: go version go1.21.0 linux/amd64
```

### Check GCC Installation
```bash
# Verify GCC is installed (required for SQLite CGO)
gcc --version

# Should show something like: gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
```

### Run the Program
```bash
# Download dependencies
go mod tidy

# Simple execution
go run database_example.go

# Or build and run
go build -o database-example database_example.go
./database-example
```

### Expected Output
```
Go SQLite Database Example
==========================
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Database connection closed
```

## 📋 System Requirements

### Operating System Support
- ✅ **Linux** (Ubuntu, Debian, CentOS, Fedora, etc.)
- ✅ **macOS** (10.14+)
- ✅ **Windows** (7, 8, 10, 11)

### Go Version Requirements
- **Minimum**: Go 1.21+
- **Recommended**: Go 1.21+
- **Latest**: Go 1.22+

### Dependencies
- **database/sql** - Go's standard database interface
- **github.com/mattn/go-sqlite3** - SQLite driver for Go

## 🛠️ Installation by Operating System

### Ubuntu/Debian
```bash
# Install Go
sudo apt update
sudo apt install golang-go

# Install GCC (required for SQLite CGO)
sudo apt install gcc

# Verify installations
go version
gcc --version
```

### CentOS/RHEL/Fedora
```bash
# Install Go
sudo yum install golang
# or for newer versions:
sudo dnf install golang

# Install GCC
sudo yum install gcc
# or
sudo dnf install gcc

# Verify installations
go version
gcc --version
```

### macOS
```bash
# Using Homebrew
brew install go

# Install Xcode Command Line Tools (includes GCC)
xcode-select --install

# Verify installations
go version
gcc --version
```

### Windows
```bash
# Download Go from https://golang.org/dl/
# Install MinGW-w64 for GCC: https://www.mingw-w64.org/

# Or use WSL2 for Linux environment
wsl --install
```

## 🏗️ Project Structure

```
go/
├── database_example.go  # Main database example file
├── go.mod              # Go module file
├── go.sum              # Dependency checksums
├── users.db            # SQLite database (created at runtime)
└── README.md          # This file
```

## 🔍 Code Features

### Database Operations
- **Create Database**: Automatic SQLite database creation
- **Create Table**: Users table with ID, name, and email fields
- **Insert Users**: Add new users with sample data
- **Query Users**: Retrieve and display all users
- **Error Handling**: Comprehensive error management

### Go Features Demonstrated
- **Structs**: User struct for data representation
- **Methods**: Database methods for operations
- **Error Handling**: Proper error checking and logging
- **Database/SQL**: Standard Go database interface
- **SQLite Integration**: CGO-based SQLite driver

## 🚀 Building and Running

### Development Mode
```bash
go run database_example.go
```

### Production Build
```bash
# Build for current platform
go build -o database-example database_example.go

# Build for specific platform
GOOS=linux GOARCH=amd64 go build -o database-example database_example.go

# Run the binary
./database-example
```

### Cross-Platform Building
```bash
# Build for Windows
GOOS=windows GOARCH=amd64 go build -o database-example.exe database_example.go

# Build for macOS
GOOS=darwin GOARCH=amd64 go build -o database-example database_example.go

# Build for Linux ARM
GOOS=linux GOARCH=arm64 go build -o database-example database_example.go
```

## 🐛 Troubleshooting

### Common Issues

#### 1. CGO Error
```
# github.com/mattn/go-sqlite3
exec: "gcc": executable file not found in $PATH
```
**Solution**: Install GCC compiler
```bash
sudo apt install gcc  # Ubuntu/Debian
sudo yum install gcc  # CentOS/RHEL
```

#### 2. Permission Denied
```
permission denied: database-example
```
**Solution**: Make executable
```bash
chmod +x database-example
```

#### 3. Module Not Found
```
go: cannot find module providing package github.com/mattn/go-sqlite3
```
**Solution**: Download dependencies
```bash
go mod tidy
```

#### 4. Database Lock Error
```
database is locked
```
**Solution**: Ensure no other process is using the database
```bash
# Check for processes using the database
lsof users.db
```

## 📚 Learning Resources

- [Go Official Documentation](https://golang.org/doc/)
- [Go Database/SQL Tutorial](https://golang.org/doc/database.html)
- [SQLite with Go](https://github.com/mattn/go-sqlite3)
- [Go Modules](https://golang.org/doc/modules/)

## 🔧 Advanced Usage

### Customizing the Example

#### Adding More Users
```go
// Add more users in the main function
err = database.InsertUser("Alice Johnson", "alice@example.com")
err = database.InsertUser("Charlie Brown", "charlie@example.com")
```

#### Modifying the User Structure
```go
type User struct {
    ID       int
    Name     string
    Email    string
    Age      int
    Created  time.Time
}
```

#### Adding More Database Operations
```go
// Add methods to Database struct
func (d *Database) GetUserByEmail(email string) (*User, error) {
    var user User
    err := d.db.QueryRow("SELECT id, name, email FROM users WHERE email = ?", email).
        Scan(&user.ID, &user.Name, &user.Email)
    if err != nil {
        return nil, err
    }
    return &user, nil
}
```

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
