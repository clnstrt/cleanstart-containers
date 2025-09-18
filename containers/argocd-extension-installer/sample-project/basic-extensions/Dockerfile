# Use the base image for ArgoCD extensions
FROM cleanstart/argocd-extension-installer:latest-dev

# Set the working directory inside the container
WORKDIR /extensions

# Copy the installation script and extension files
COPY install.sh .
COPY hello_world.py .

# Switch to the root user to gain permission to change file permissions
USER root

# Make the installation script executable
RUN chmod +x install.sh

# Run the installation script to configure the extension
ENTRYPOINT ["./install.sh"]