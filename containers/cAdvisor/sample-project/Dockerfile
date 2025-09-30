FROM cleanstart/cadvisor:latest-dev

USER clnstrt

ENV CADVISOR_HEALTHCHECK_URL=http://localhost:8080/healthz
ENV LD_PRELOAD=
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/usr/bin/cadvisor"]
CMD ["-logtostderr"]
