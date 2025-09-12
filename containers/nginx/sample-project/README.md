# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - Nginx container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart Nginx image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/nginx:latest
```
```bash
docker pull cleanstart/nginx:latest-dev
```

## If you have the Nginx image pulled, you can also run your program directly:
```bash
docker run --rm -p 8080:80 -v $(pwd):/usr/share/nginx/html cleanstart/nginx:latest
```
## Output 
```bash
nginx: [alert] could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
2024/01/15 10:30:45 [notice] 1#1: using the "epoll" event method
2024/01/15 10:30:45 [notice] 1#1: nginx/1.25.3
2024/01/15 10:30:45 [notice] 1#1: start worker processes
2024/01/15 10:30:45 [notice] 1#1: start worker process 7
```

## Access the Web Server
Open your browser and go to: **http://localhost:8080**

You should see the default Nginx welcome page or your custom HTML content.

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/beginners_guide.html)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
