#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker was not found on this system."
  exit 0
fi

PRUNE="${PRUNE:-0}"

echo "== Docker maintenance =="
docker version --format 'Client: {{.Client.Version}}  Server: {{.Server.Version}}' 2>/dev/null || true

echo
echo "== Disk usage =="
docker system df || true

echo
echo "== Containers =="
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}' || true

echo
echo "== Images with dangling layers =="
docker images --filter dangling=true || true

if [ "$PRUNE" = "1" ]; then
  echo
  echo "Pruning stopped containers, unused networks, dangling images, and build cache..."
  docker system prune -f
else
  echo
  echo "Set PRUNE=1 to reclaim unused Docker space."
fi
