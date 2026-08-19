#!/bin/sh
set -e

echo "=== openGym Standalone Cloud Launcher ==="

# Set environment variables
export PORT=3000
export DATA_DIR="${DATA_DIR:-/data}"

mkdir -p "$DATA_DIR"

# Dynamic Render PORT binding
if [ -n "$PORT_RENDER" ] || [ -n "$PORT" ]; then
  BIND_PORT="${RENDER_PORT:-${PORT_ENV:-${PORT:-80}}}"
fi

# Substitute listen port in nginx if PORT env is set by hosting provider
if [ -n "$PORT" ] && [ "$PORT" != "3000" ]; then
  sed -i "s/listen 80;/listen ${PORT};/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true
  sed -i "s/listen 10000;/listen ${PORT};/g" /etc/nginx/conf.d/default.conf 2>/dev/null || true
fi

# Start internal Node API server
echo "Starting internal Node.js API (port 3000)..."
node /app/api/server.js &

# Wait for API to start
sleep 2

# Start Nginx
echo "Starting Nginx frontend web server..."
exec nginx -g "daemon off;"
