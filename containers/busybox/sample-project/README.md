# 🚀 Hello from Busybox!!! 

A simple  program to run on CleanStart - BusyBox container. 

### Pull CleanStart BusyBox image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/busybox:latest-dev
```

## Have sh script 
```bash
#!/bin/sh
echo "🚀 Cleanstart BusyBox started as user: $(whoami)"
echo "📦 BusyBox version: $(busybox | head -n 1)"

# heartbeat logs every 5 sec
while true; do
  echo "⏳ Busybox is a combination of UNIX utilities and is a single binary! $(date)"
  sleep 5
done
```

### Build with Dockerfile
```bash
FROM cleanstart/busybox:latest-dev

# Switch to root to copy and chmod
USER root

# Copy the script
COPY start.sh /usr/local/bin/busybox.sh

# Give execution permission
RUN chmod +x /usr/local/bin/busybox.sh

# Switch back to the original user
USER clnstrt

# Run the script by default
ENTRYPOINT ["/usr/local/bin/busybox.sh"]
```

## Build with dockerfile
```bash
docker build --no-cache -t my-cleanstart-busybox .
```

## Run with dockerfile
```bash
 docker run --rm my-cleanstart-busybox
 ```

## Output 
```bash
🚀 Cleanstart BusyBox started as user: clnstrt
📦 BusyBox version: BusyBox v1.37.0 (2025-07-11 07:44:34 UTC) multi-call binary.
⏳ Busybox is a combination of UNIX utilities and is a single binary! (Date)
⏳ Busybox is a combination of UNIX utilities and is a single binary! (Date)
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
