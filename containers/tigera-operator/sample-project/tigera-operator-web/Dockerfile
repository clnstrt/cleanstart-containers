FROM cleanstart/tigera-operator:latest-dev

WORKDIR /web
COPY index.html /web/

# Tiny shell HTTP server (BusyBox netcat compatible)
RUN echo '#!/bin/sh' > /web/serve.sh \
 && echo 'while true; do' >> /web/serve.sh \
 && echo '  { echo -e "HTTP/1.1 200 OK\\r\\nContent-Type: text/html\\r\\n\\r\\n"; cat /web/index.html; } | nc -lk -p 8080' >> /web/serve.sh \
 && echo 'done' >> /web/serve.sh \
 && chmod +x /web/serve.sh

ENTRYPOINT ["/web/serve.sh"]
