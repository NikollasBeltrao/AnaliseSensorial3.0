# Use the official Node.js image as the base image with the desired version
FROM node:14.15.1

# Set the working directory in the container
WORKDIR /app

# Install Ionic and Cordova globally with the specified versions
RUN npm install -g ionic@5.4.16 cordova@10.0.0

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Expose the port that the app will run on (if applicable)
EXPOSE 8100

# Start the app when the container runs
CMD ["ionic", "serve", "--port", "8100", "--address", "0.0.0.0"]
