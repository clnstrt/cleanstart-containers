# 🚀 Hello World!!! 

A simple **HELLO WORLD** program to run on CleanStart - BusyBox container. 

## To run the Hello World without Dockerfile to avoid making simple things complex

### Pull CleanStart BusyBox image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/busybox:latest
```
```bash
docker pull cleanstart/busybox:latest-dev
```

## If you have the BusyBox image pulled, you can also run your program directly:
```bash
docker run --rm -v $(pwd):/app -w /app cleanstart/busybox:latest sh basic-examples/filesystem.sh
```
## Output 
```bash
=== BusyBox Filesystem Demo ===
Creating sample files...
Sample files created successfully!
Listing files in /tmp/busybox-sample:
-rw-r--r--    1 1001     1001           12 Jan 15 10:30:45 2024 file1.txt
-rw-r--r--    1 1001     1001           12 Jan 15 10:30:45 2024 file2.txt
-rw-r--r--    1 1001     1001           12 Jan 15 10:30:45 2024 file3.txt
Searching for files containing 'sample':
/tmp/busybox-sample/file1.txt:This is sample file 1
/tmp/busybox-sample/file2.txt:This is sample file 2
/tmp/busybox-sample/file3.txt:This is sample file 3
Filesystem demo completed!
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [BusyBox Official Documentation](https://busybox.net/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).