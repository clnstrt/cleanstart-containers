🚀 Hello World!!!
A simple HELLO WORLD program to run on CleanStart - Go container.

To run the Hello World without Dockerfile to avoid making simple things complex
Pull CleanStart Go image from Docker Hub - CleanStart
docker pull cleanstart/go:latest
docker pull cleanstart/go:latest-dev
If you have the Go image pulled, you can also run your program directly:
docker run --rm -v $(pwd):/app -w /app cleanstart/go:latest go run hello_world.go
Output
Hello, World!
Welcome to Go!
What's your name? Nice to meet you, !
📚 Resources
Verified Docker Image Publisher - CleanStart
Go Official Documentation
🤝 Contributing
Feel free to contribute to this project by:

Reporting bugs
Suggesting new features
Submitting pull requests
Improving documentation
📄 License
This project is open source and available under the MIT License.