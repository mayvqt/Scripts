#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Optimization: Disk and filesystem optimization ==="
echo "Started: $(date)"

if command -v e4defrag >/dev/null 2>&1; then
  echo "Analyzing ext4 fragmentation..."
  while read -r fs type options; do
    if [ "$type" = "ext4" ]; then
      echo "Analyzing $fs..."
      e4defrag -c "$fs" 2>/dev/null || true
    fi
  done < <(findmnt -rn -o TARGET,FSTYPE,OPTIONS)
else
  echo "e4defrag not found; skipping ext4 fragmentation analysis."
fi

if command -v fstrim >/dev/null 2>&1; then
  echo "Trimming supported filesystems..."
  fstrim -av || true
fi

echo "Checking filesystem usage..."
df -hT

echo "Finding large files under /var/log and /tmp..."
find /var/log /tmp -xdev -type f -size +100M -printf '%s %p\n' 2>/dev/null | sort -nr | head -20 | awk '{printf "%.1fM %s\n", $1/1048576, $2}' || true

if command -v docker >/dev/null 2>&1; then
  echo "Docker disk usage:"
  docker system df || true
fi

echo "Finished: $(date)"
