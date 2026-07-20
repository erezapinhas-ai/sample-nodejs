# ----- Stage 1: Build & Install dependencies -----
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Copy package files first for better layer caching
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# ----- Stage 2: Production Runtime -----
FROM node:18-alpine

WORKDIR /usr/src/app

# Set environment to production
ENV NODE_ENV=production

# Copy node_modules and app code from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY package*.json ./
COPY . .

# Security best practice: Run as non-root user
USER node

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
