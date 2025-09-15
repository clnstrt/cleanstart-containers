# # Use official Node LTS image
# FROM cleanstart/node:latest-dev

# # Set working directory
# WORKDIR /app

# # Copy package files
# COPY package*.json ./

# # Install dependencies
# RUN npm install 

# # Copy the rest of the app
# COPY . .

# # Expose port (if your app uses one)
# EXPOSE 3000

# # Start the app
# ENTRYPOINT  ["node", "app.js"]


# Use official Node LTS image
FROM cleanstart/node:latest-dev

# Set working directory
WORKDIR /app

# Copy package.json
COPY node-webs/package.json ./

# Install dependencies
RUN npm install --production

# Copy the rest of the app
COPY node-webs/ ./

# Copy views from parent directory
COPY views ./views

# Add non-root user
RUN addgroup -g 1001 -S nodeapp \
    && adduser -u 1001 -S nodeapp -G nodeapp \
    && chown -R nodeapp:nodeapp /app

USER nodeapp

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]

