# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - glibc container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart glibc image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/glibc:latest
```
```bash
docker pull cleanstart/glibc:latest-dev
```

## If you have the glibc image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/glibc:latest gcc -o hello hello.c && ./hello
```
## Output 
```bash
Hello, World!
Welcome to glibc!
What's your name? Nice to meet you, !
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [glibc Official Documentation](https://www.gnu.org/software/libc/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
