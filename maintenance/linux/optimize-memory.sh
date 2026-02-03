#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Optimization: System memory and cache management =="
echo "Started: $(date)"

# Free up page cache, dentries, and inodes
echo "Clearing caches..."
sync && echo 3 > /proc/sys/vm/drop_caches

# Optimize swappiness (default 60, lower = prefer RAM over swap)
echo "Setting swappiness to 10..."
sysctl -w vm.swappiness=10 || true

# Optimize inode cache based on available memory
TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
echo "Optimizing inode cache ($(($TOTAL_MEM / 1024))MB RAM available)..."
sysctl -w fs.inode-max-count=$((TOTAL_MEM / 10)) || true

# Optimize network stack for efficiency
echo "Optimizing network settings..."
sysctl -w net.ipv4.tcp_tw_reuse=1 || true
sysctl -w net.ipv4.tcp_fin_timeout=30 || true
sysctl -w net.core.somaxconn=4096 || true
sysctl -w net.ipv4.tcp_max_syn_backlog=4096 || true

# Optimize file descriptor limits
echo "Optimizing file descriptor limits..."
sysctl -w fs.file-max=$((TOTAL_MEM / 5)) || true

echo "Finished: $(date)"
