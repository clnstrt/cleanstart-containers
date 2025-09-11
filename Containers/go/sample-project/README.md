# 🚀 Go Web Application

A simple **User Management System** built with Go as well as **HELLO WORLD** program.

## 📂 Project Structure
```bash
go-web/
├── main.go          # Application entry point
├── go.mod           # Dependencies
├── go.sum           # Dependency checksums
├── templates/       # HTML templates
│   ├── index.html   # Main page
│   ├── add_user.html
│   └── edit_user.html
├── users.db         # SQLite database
├── Dockerfile       # Build instructions
└── docker-compose.yml #For service up an down
```

## 🎮 Features
- Add new users  
- View all users  
- Edit user details  
- Delete users  

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Go image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/go:latest
```
```bash
docker pull cleanstart/go:latest-dev
```

## If you  have the Go image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/go:latest go run hello_world.go
```
## Output 
```bash
Hello, World!
Welcome to Go!
What's your name? Nice to meet you, !

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Go Official Documentation](https://golang.org/doc/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
```
