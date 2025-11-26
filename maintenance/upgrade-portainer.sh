#!/usr/bin/env bash
set -euo pipefail

# Idempotent script to stop/remove existing Portainer, pull latest image and run container
# Location: maintenance/deploy-portainer.sh

DOCKER_BIN=docker
if [ "$EUID" -ne 0 ]; then
  DOCKER_CMD="sudo $DOCKER_BIN"
else
  DOCKER_CMD="$DOCKER_BIN"
fi

IMAGE="portainer/portainer-ce:latest"
NAME="portainer"
VOLUME_NAME="portainer_data"

echo "[portainer] Using command: $DOCKER_CMD"

if ! command -v $DOCKER_BIN >/dev/null 2>&1; then
  echo "Error: docker not found. Install Docker or run this on a host with Docker available." >&2
  exit 2
fi

echo "[portainer] Checking for existing container..."
EXISTING=$($DOCKER_CMD ps -a -q -f name=^${NAME}$ || true)
if [ -n "$EXISTING" ]; then
  echo "[portainer] Stopping container '$NAME'..."
  $DOCKER_CMD stop $NAME || true
  echo "[portainer] Removing container '$NAME'..."
  $DOCKER_CMD rm $NAME || true
else
  echo "[portainer] No existing container named '$NAME' found."
fi

echo "[portainer] Pulling latest image: $IMAGE"
$DOCKER_CMD pull $IMAGE

echo "[portainer] Ensuring volume '$VOLUME_NAME' exists..."
if ! $DOCKER_CMD volume ls -q | grep -wq "$VOLUME_NAME"; then
  $DOCKER_CMD volume create "$VOLUME_NAME"
  echo "[portainer] Created volume '$VOLUME_NAME'."
else
  echo "[portainer] Volume '$VOLUME_NAME' already exists."
fi

echo "[portainer] Starting container '$NAME'..."
$DOCKER_CMD run -d -p 9000:9000 -p 8000:8000 \
  --name $NAME --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${VOLUME_NAME}:/data \
  $IMAGE

echo "[portainer] Done. Access Portainer UI at: http://<YOUR_SERVER_IP>:9000"

exit 0
