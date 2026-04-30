#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

echo "== Maintenance: cleanup temporary files and apt lists =="
echo "Started: $(date)"

if command -v apt-get >/dev/null 2>&1; then
  log "Cleaning apt package cache..."
  apt-get -y autoremove || true
  apt-get -y autoclean || true
fi

log "Cleaning temporary files..."
find /tmp -xdev -mindepth 1 -maxdepth 1 -mtime +7 -exec rm -rf {} + || true
find /var/tmp -xdev -mindepth 1 -mtime +30 -exec rm -rf {} + || true

if command -v docker >/dev/null 2>&1; then
  log "Docker found. Reclaiming dangling images, containers, and build cache..."
  docker system prune -f || true
fi

log "Disk usage after cleanup:"
df -h / /tmp 2>/dev/null || df -h

echo "Finished: $(date)"
