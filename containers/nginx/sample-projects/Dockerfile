# # Use the CleanStart NGINX base image
# FROM cleanstart/nginx:latest-dev

# # Copy custom HTML to NGINX default HTML location
# COPY index.html /usr/share/nginx/html/index.html

# # Expose port 8080 (mapped from host)
# EXPOSE 8080

# # Run NGINX in the foreground
# ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]


FROM cleanstart/nginx:latest-dev

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]


