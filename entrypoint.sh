#!/bin/sh
set -e

export PORT=3000
export DATA_DIR=/tmp/data

echo "=== Starting openGym Node API (port 3000) ==="
(cd /app/api && node server.js) > /tmp/node-api.log 2>&1 &

sleep 2

echo "=== Starting Nginx Web Server ==="
exec nginx -g "daemon off;"
