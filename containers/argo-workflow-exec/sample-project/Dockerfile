FROM cleanstart/argo-workflow-exec:latest-dev
USER root
COPY test-argoexec.sh /test-argoexec.sh
RUN chmod +x /test-argoexec.sh
ENTRYPOINT ["/test-argoexec.sh"]
CMD []