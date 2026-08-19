FROM node:22-alpine AS build
WORKDIR /app

# Build Frontend
COPY frontend/package.json frontend/package-lock.json* ./frontend/
RUN cd frontend && npm install
COPY frontend/ ./frontend/
RUN cd frontend && npx cross-env VITE_IMG_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/images/ VITE_GIF_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/videos/ npm run build

# Install API dependencies
COPY api/package.json api/package-lock.json* ./api/
RUN cd api && npm install
COPY api/ ./api/

FROM nginx:alpine
RUN apk add --no-cache nodejs bash

WORKDIR /app
COPY --from=build /app/frontend/dist /usr/share/nginx/html
COPY --from=build /app/api /app/api
COPY web/nginx.conf /etc/nginx/conf.d/default.conf

# Auto-start Node API on port 3000 via Nginx entrypoint hook
RUN mkdir -p /docker-entrypoint.d && \
    echo '#!/bin/sh' > /docker-entrypoint.d/99-start-node.sh && \
    echo 'export PORT=3000' >> /docker-entrypoint.d/99-start-node.sh && \
    echo 'export DATA_DIR=/tmp/data' >> /docker-entrypoint.d/99-start-node.sh && \
    echo 'echo "Starting background Node.js API on port 3000..."' >> /docker-entrypoint.d/99-start-node.sh && \
    echo 'node /app/api/server.js > /tmp/node-api.log 2>&1 &' >> /docker-entrypoint.d/99-start-node.sh && \
    chmod +x /docker-entrypoint.d/99-start-node.sh

EXPOSE 80 10000 3000
