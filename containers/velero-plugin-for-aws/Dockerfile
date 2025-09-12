# Velero Plugin for AWS
# Based on the official Velero image with AWS plugin support

FROM velero/velero:v1.11.0

# Install AWS plugin
RUN velero plugin add velero/velero-plugin-for-aws:v1.7.0

# Set working directory
WORKDIR /workspace

# Copy sample projects and scripts
COPY sample-project/ /workspace/sample-project/

# Install additional tools for sample projects
RUN apk add --no-cache \
    jq \
    curl \
    bash \
    && rm -rf /var/cache/apk/*

# Set environment variables
ENV VELERO_PLUGIN_DIR=/plugins
ENV AWS_DEFAULT_REGION=us-west-2

# Create a non-root user
RUN addgroup -g 1000 velero && \
    adduser -D -s /bin/bash -u 1000 -G velero velero

# Change ownership of workspace
RUN chown -R velero:velero /workspace

# Switch to non-root user
USER velero

# Default command
CMD ["velero", "--help"]
