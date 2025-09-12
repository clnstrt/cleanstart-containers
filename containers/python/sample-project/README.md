# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Python container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Python image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/python:latest
```
```bash
docker pull cleanstart/python:latest-dev
```

## If you have the Python image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/python:latest python hello_world.py
```
## Output 
```bash
Hello, World!
Welcome to Python!
What's your name? Nice to meet you, !
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Python Official Documentation](https://docs.python.org/)
- [Flask Documentation](https://flask.palletsprojects.com/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
