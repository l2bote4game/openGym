#!/bin/bash
set -e

echo "=== openGym Standalone Launcher ==="

# Internal port for Node API
export API_PORT=3000
export DATA_DIR="${DATA_DIR:-/data}"

mkdir -p "$DATA_DIR"

# Public port assigned by Render/Cloud provider
PUBLIC_PORT="${PORT:-10000}"

echo "Updating Nginx configuration for public port ${PUBLIC_PORT}..."
sed -i "s/listen 80;/listen ${PUBLIC_PORT};/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true
sed -i "s/listen 10000;/listen ${PUBLIC_PORT};/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true

echo "Starting Node.js API server on internal port 3000..."
node /app/api/server.js &

# Give API time to initialize
sleep 2

echo "Starting Nginx web server on public port ${PUBLIC_PORT}..."
exec nginx -g "daemon off;"
