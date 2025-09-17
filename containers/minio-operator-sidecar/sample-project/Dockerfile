FROM cleanstart/minio-operator-sidecar:latest-dev

# Switch to root temporarily
USER root

# Update and install only lightweight tools available in custom repo
RUN apk update && apk add --no-cache bash curl


# Switch back to the non-root user already defined in base
USER clnstrt

# Default to bash shell for debugging
ENTRYPOINT ["/minio-operator-sidecar"]
