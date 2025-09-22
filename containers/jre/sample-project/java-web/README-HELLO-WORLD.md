# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - jre container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart jre image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/jre:latest
```
```bash
docker pull cleanstart/jre:latest-dev
```

## If you have the jre image pulled, you can also run your program directly without Dockerfile:
```bash
echo 'public class HelloWorld { public static void main(String[] args) { System.out.println("Hello, World!"); } }' > HelloWorld.jre
```
```bash
docker run --rm -v $(pwd):/app --entrypoint sh cleanstart/jdk:latest-dev -c "jrec HelloWorld.jre && jre HelloWorld"
```

## Output 
```bash
Hello, World!
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [jre Official Documentation](https://docs.oracle.com/en/jre/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
