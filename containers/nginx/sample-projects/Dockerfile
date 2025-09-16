# Use the CleanStart NGINX base image
FROM cleanstart/nginx:latest-dev

COPY . .

EXPOSE 8080

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]




