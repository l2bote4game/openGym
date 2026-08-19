FROM node:22-slim

WORKDIR /app

# Build Frontend
COPY frontend/package.json frontend/package-lock.json* ./frontend/
RUN cd frontend && npm install
COPY frontend/ ./frontend/
RUN cd frontend && npx cross-env VITE_IMG_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/images/ VITE_GIF_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/videos/ npm run build

# Install API dependencies and copy API source
COPY api/ ./api/
RUN cd api && npm install

WORKDIR /app/api

EXPOSE 80 3000 8080 10000

ENV PORT=10000
ENV PUBLIC_DIR=/app/frontend/dist
ENV DATA_DIR=/tmp/data

CMD ["node", "server.js"]
