FROM node:22-alpine AS build
WORKDIR /app

# Build Frontend with CDN Exercise Media
COPY frontend/package.json frontend/package-lock.json* ./frontend/
RUN cd frontend && npm install
COPY frontend/ ./frontend/
RUN cd frontend && npx cross-env VITE_IMG_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/images/ VITE_GIF_BASE=https://cdn.jsdelivr.net/gh/hasaneyldrm/exercises-dataset@7455efae41b330c265e7cd4b78dfa848e7ce5ebd/videos/ npm run build

# Install API dependencies
COPY api/package.json api/package-lock.json* ./api/
RUN cd api && npm install

FROM node:22-alpine
WORKDIR /app
COPY --from=build /app/frontend/dist /app/frontend/dist
COPY --from=build /app/api /app/api

EXPOSE 3000 8080 10000

ENV PORT=10000
ENV PUBLIC_DIR=/app/frontend/dist
ENV DATA_DIR=/data

CMD ["node", "api/server.js"]
