FROM metallb/controller:v0.15.2

# Set working directory
WORKDIR /app

# Copy sample projects and configurations
COPY sample-project/ /app/sample-project/
COPY README.md /app/README.md

# Set environment variables
ENV METALLB_NAMESPACE=metallb-system
ENV METALLB_LOG_LEVEL=info

# Expose default ports
EXPOSE 7472

# Default command
CMD ["controller", "--help"]
