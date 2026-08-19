#!/bin/sh
set -e

export DATA_DIR="${DATA_DIR:-/tmp/data}"
mkdir -p "$DATA_DIR"

echo "=== Starting openGym Unified Server on Port ${PORT:-10000} ==="
cd /app/api
exec node server.js
