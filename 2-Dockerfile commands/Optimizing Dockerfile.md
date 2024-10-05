=============================================================================================
Optimizing Docker image from Dockerfile
=============================================================================================
# Minimal base image (Use alpine instead of ubuntu image)
FROM alpine:latest

# Combine RUN commands
RUN apt-get update
RUN apt-get install -y package1 package2
RUN rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
apt-get install -y \
    package1 \
    package2 && \
    rm -rf /var/lib/apt/lists/*

# Remove unnecessary files (clean up cache)
RUN apt-get install -y package && rm -rf /var/lib/apt/lists/*

# .dockerignore (Exclude files and directories that aren’t needed in the image)
node_modules
*.log
*.tmp
.git

# Multi-stage builds (separate build dependencies from runtime dependencies)
    # Stage 1: Build
    FROM golang:alpine AS builder
    WORKDIR /app
    COPY . .
    RUN go build -o myapp .

    # Stage 2: Run
    FROM alpine:latest
    COPY --from=builder /app/myapp /usr/local/bin/
    CMD ["myapp"]

# Specific Tags (Avoid using latest instead use specific version tags for consistency)
FROM node:14

# Layer Caching (place less frequently changed commands at the top)
    # Install dependencies first
    COPY package.json package-lock.json ./
    RUN npm install

    # Copy the rest of the application
    COPY . .

# Non-root user (run your application as a non-root user to improve security)
RUN adduser -D myuser
USER myuser

# Health checks
HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1