# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - jdk container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart jdk image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/jdk:latest
```
```bash
docker pull cleanstart/jdk:latest-dev
```

## If you have the jdk image pulled, you can also run your program directly without Dockerfile:
```bash
echo 'public class HelloWorld { public static void main(String[] args) { System.out.println("Hello, World!"); } }' > HelloWorld.jdk
```
```bash
docker run --rm -v $(pwd):/app --entrypoint sh cleanstart/jdk:latest-dev -c "jdkc HelloWorld.jdk && jdk HelloWorld"
```

## Output 
```bash
Hello, World!
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [jdk Official Documentation](https://docs.oracle.com/en/jdk/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
