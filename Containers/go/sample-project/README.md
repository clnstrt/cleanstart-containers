# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Go container. 

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
```

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

