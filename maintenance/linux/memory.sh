#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Optimization: System memory and cache management =="
echo "Started: $(date)"

echo "Clearing caches..."
sync
echo 3 > /proc/sys/vm/drop_caches

echo "Setting swappiness to 10..."
sysctl -w vm.swappiness=10 || true

echo "Reducing inode/dentry cache pressure..."
sysctl -w vm.vfs_cache_pressure=50 || true

echo "Memory summary:"
free -h || true
echo "Finished: $(date)"
