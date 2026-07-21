#!/bin/bash
set -e

echo "[*] Starting Docker daemon..."

# Check if Docker daemon is already running
if ! docker ps > /dev/null 2>&1; then
    # Start dockerd in background
    sudo dockerd --storage-driver=overlay2 \
        --log-driver=json-file \
        --insecure-registry=localhost:5000 &
    
    DOCKER_PID=$!
    echo "[*] Docker daemon PID: $DOCKER_PID"
    
    # Wait for daemon to be ready
    echo "[*] Waiting for Docker daemon to be ready..."
    for i in {1..60}; do
        if docker ps > /dev/null 2>&1; then
            echo "[✓] Docker daemon is ready!"
            break
        fi
        echo "[*] Attempt $i/60... waiting"
        sleep 1
    done
    
    if ! docker ps > /dev/null 2>&1; then
        echo "[✗] Docker daemon failed to start"
        exit 1
    fi
fi

echo "[✓] Docker is running"
docker ps