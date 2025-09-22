FROM cleanstart/velero-plugin-for-aws:latest

WORKDIR /web
COPY index.html /web/
COPY server.sh /web/server.sh

EXPOSE 8080
# ENTRYPOINT ["busybox", "sh", "/web/server.sh"]
ENTRYPOINT ["busybox", "sh", "/web/server.sh"]
