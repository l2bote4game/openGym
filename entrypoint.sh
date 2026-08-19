#!/bin/sh
set -e

export PORT=3000
export DATA_DIR=/tmp/data

echo "=== Starting openGym Node API (port 3000) ==="
node /app/api/server.js &

sleep 2

echo "=== Starting Nginx Web Server ==="
exec nginx -g "daemon off;"
