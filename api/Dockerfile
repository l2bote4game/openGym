FROM node:22-alpine

WORKDIR /app

# Copy API and pre-built frontend dist directly
COPY frontend/dist /app/frontend/dist
COPY api/ /app/api/

RUN cd /app/api && npm install --omit=dev

WORKDIR /app/api

EXPOSE 80 3000 8080 10000

ENV PORT=80
ENV PUBLIC_DIR=/app/frontend/dist
ENV DATA_DIR=/tmp/data

CMD ["node", "server.js"]
