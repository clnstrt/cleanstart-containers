FROM cleanstart/node:latest

# Set proper working directory
WORKDIR /app

# Copy app file into /app
COPY hello_world.js .

# Add non-root user
RUN addgroup -g 1001 -S nodeapp \
    && adduser -u 1001 -S nodeapp -G nodeapp \
    && chown -R nodeapp:nodeapp /app

USER nodeapp

EXPOSE 3000

ENTRYPOINT ["node", "hello_world.js"]

