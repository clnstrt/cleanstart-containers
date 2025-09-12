# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Java container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Java image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/java:latest
```
```bash
docker pull cleanstart/java:latest-dev
```

## If you have the Java image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/java:latest javac HelloWorld.java && java HelloWorld
```
## Output 
```bash
Hello, World!
Welcome to Java!
What's your name? Nice to meet you, !
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Java Official Documentation](https://docs.oracle.com/en/java/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).