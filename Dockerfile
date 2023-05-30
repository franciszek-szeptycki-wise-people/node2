# Specify the base image
FROM node

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the React application
RUN cd client && npm install && npm run build && cd ..

# Expose the port on which your Node.js application runs
EXPOSE 3000

# Start the Node.js application
CMD ["node", "app.js"]
