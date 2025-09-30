FROM cleanstart/argocd-extension-installer:latest-dev

WORKDIR /extensions

USER root

# Create web directory and index file
RUN mkdir -p /var/www && \
    echo '<h1>Hello from ArgoCD Extension!</h1><p>Status: Running</p>' > /var/www/index.html

# Copy script
COPY install.sh .
RUN chmod +x install.sh

EXPOSE 3000

ENTRYPOINT ["sh", "./install.sh"]