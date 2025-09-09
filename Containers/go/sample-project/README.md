# 🚀 Go Web Application 

Welcome to your first Go web application! This guide is designed for college students who are new to programming and want to learn how to build web applications using Go.

##  What This Application Does

This is a **User Management System** - think of it like a simple contact list or mini social media app where you can:
- **Add new users** (like adding friends to your phone contacts)
- **View all users** (like scrolling through your contact list)
- **Edit user information** (like updating a friend's phone number)
- **Delete users** (like removing a contact)
- 

## 🚀 Quick Start (The Easy Way)

### Step 1: Install Docker
**What is Docker?** Docker is like a "magic box" that contains everything your application needs to run. It's like having a mini-computer inside your computer!

**How to install:**
1. Go to [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Download Docker Desktop for your computer (Windows/Mac/Linux)
3. Install it like any other software
4. Start Docker Desktop

**How to check if it's working:**
```bash
docker --version
```
If you see something like "Docker version 20.10.x", you're good to go!

### Step 2: Run the Application
**What we're doing:** We're going to start your web application using Docker.

```bash
# Navigate to the project folder
cd images/go/sample-project/go-web

# Start the application
docker run -p 8080:8080 go-web-app
```

**What this means:**
- `docker run` = "Start a new container (magic box)"
- `-p 8080:8080` = "Connect port 8080 on your computer to port 8080 in the container"
- `go-web-app` = "The name of our application"

### Step 3: Open Your Web Browser
1. Open your web browser (Chrome, Firefox, Safari, etc.)
2. Go to: `http://localhost:8080`
3. You should see a web page with "User Management System"

**What is localhost?** Localhost means "this computer." So `http://localhost:8080` means "go to the website running on my computer at port 8080."

## 🎮 How to Use the Application

### Adding a New User
1. Click the "Add New User" button
2. Fill in the form:
   - **Name**: Enter the person's name (e.g., "John Doe")
   - **Email**: Enter their email (e.g., "john@example.com")
   - **Phone**: Enter their phone number (e.g., "123-456-7890")
3. Click "Add User"
4. You'll see the new user appear in the list!

### Viewing All Users
- All users are automatically displayed on the main page
- You can see their name, email, and phone number

### Editing a User
1. Click the "Edit" button next to any user
2. Change the information in the form
3. Click "Update User"
4. The user's information will be updated!

### Deleting a User
1. Click the "Delete" button next to any user
2. Confirm the deletion
3. The user will be removed from the list

## 🔧 For Advanced Beginners (Optional)

### What's Inside the Magic Box?

**The Application Structure:**
```
go-web/
├── main.go          # The main program file (like the "brain" of the app)
├── templates/       # HTML files (like the "face" of the app)
│   ├── index.html   # The main page
│   ├── add_user.html # The "add user" page
│   └── edit_user.html # The "edit user" page
├── go.mod           # Lists all the tools the app needs
├── Dockerfile       # Instructions for building the magic box
└── users.db         # The database (where user information is stored)
```

### Understanding the Code (Simplified)

**main.go** - The main program:
```go
// This is like the "brain" of your application
// It tells the computer what to do when someone visits your website

func main() {
    // Start the web server
    // Listen for people visiting your website
    // Show them the right pages
}
```

**What each part does:**
- `GET /` = "When someone visits the main page, show them the user list"
- `POST /api/users` = "When someone submits the add user form, save the new user"
- `GET /api/users` = "When someone asks for the user list, give them the data"

## 🐛 Troubleshooting (Common Problems)

### Problem: "Docker command not found"
**Solution:** Docker isn't installed or isn't running
1. Make sure Docker Desktop is installed
2. Start Docker Desktop
3. Wait for it to fully start (you'll see a green icon)

### Problem: "Port 8080 is already in use"
**Solution:** Something else is using port 8080
```bash
# Use a different port
docker run -p 8081:8080 go-web-app
# Then go to http://localhost:8081
```

### Problem: "Cannot connect to the application"
**Solution:** Check if the container is running
```bash
# See all running containers
docker ps

# If you don't see go-web-app, start it again
docker run -p 8080:8080 go-web-app
```

### Problem: "The page doesn't load"
**Solution:** Check your browser
1. Make sure you're going to `http://localhost:8080` (not `https://`)
2. Try a different browser
3. Check if your firewall is blocking the connection


## 🔗 What's Next?

After you're comfortable with this application, you can:

1. **Try other sample projects:**
   - Python web app (similar but uses Python)
   - Java web app (similar but uses Java)
   - Node.js web app (similar but uses JavaScript)

2. **Learn more about Go:**
   - [Go Official Tutorial](https://golang.org/doc/tutorial/)
   - [Go by Example](https://gobyexample.com/)

3. **Learn more about web development:**
   - HTML basics
   - CSS styling
   - JavaScript for interactivity

## 🤝 Getting Help

If you get stuck:
1. **Check the troubleshooting section above**
2. **Ask your classmates or teacher**
3. **Search online** (Google is your friend!)
4. **Join programming communities** (Reddit r/learnprogramming, Discord servers)

