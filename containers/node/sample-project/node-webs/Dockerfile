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
FROM cleanstart/node:latest

# Set working directory
WORKDIR /app

# Copy ONLY package.json first
COPY package.json ./
# If you also have package-lock.json, copy it too
COPY package-lock.json* ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]

