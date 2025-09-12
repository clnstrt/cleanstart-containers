# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Node.js container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Node.js image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/node:latest
```
```bash
docker pull cleanstart/node:latest-dev
```

## If you have the Node.js image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/node:latest node hello_world.js
```
## Output 
```bash
Hello, World!
Welcome to Node.js!
What's your name? Nice to meet you, !
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Node.js Official Documentation](https://nodejs.org/en/docs/)
- [Express.js Documentation](https://expressjs.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
