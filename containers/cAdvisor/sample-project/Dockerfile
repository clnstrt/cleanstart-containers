# Start from a base image (e.g., debian:bullseye-slim or a similar minimal Linux distribution)
# The `Os` and `Architecture` fields confirm it's a linux/amd64 image.
# The user `clnstrt` suggests it's a custom user.
FROM cleanstart/cadvisor:latest-dev

# The `User` field indicates the user was switched.
# The user `clnstrt` was created and switched to.
USER clnstrt

# The `Env` field shows environment variables being set.
ENV CADVISOR_HEALTHCHECK_URL=http://localhost:8080/healthz
ENV LD_PRELOAD=
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# The `Entrypoint` is the main executable that runs when the container starts.
# The `Cmd` is the default argument passed to the entrypoint.
# The combination of `Entrypoint` and `Cmd` means the container runs:
# `/usr/bin/cadvisor -logtostderr`
ENTRYPOINT ["/usr/bin/cadvisor"]
CMD ["-logtostderr"]

# The `Size` field is the total size of the image, including all layers.
# The `RootFS` section shows the hashes of the layers.
# This implies that the application binary and its dependencies were added
# in one or more layers, likely via a `COPY` or `ADD` command.
# For example, something like this:
# COPY --from=builder /path/to/cadvisor /usr/bin/cadvisor
# COPY --from=builder /path/to/certs /etc/ssl/certs/ca-certificates.crt