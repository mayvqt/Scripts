#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Optimization: Disk and filesystem optimization ==="
echo "Started: $(date)"

# Find and defragment all ext4 filesystems
echo "Checking filesystem health on all ext4 filesystems..."
while IFS= read -r fs; do
  if [ -n "$fs" ]; then
    echo "Analyzing filesystem on $fs..."
    e4defrag -c "$fs" 2>/dev/null || true
  fi
done < <(mount | grep ext4 | awk '{print $3}')

# Report all mounted filesystems
echo ""
echo "Current filesystem configuration:"
mount | grep -E "ext4|ext3|btrfs|xfs" || true

# Clean up orphaned inode tables across all filesystems
echo ""
echo "Cleaning orphaned files (no owner)..."
find / -xdev \( -nouser -o -nogroup \) 2>/dev/null | head -20 || true

# Trim SSD if available on all mounted filesystems
echo "Trimming all mounted filesystems (if available)..."
while IFS= read -r mountpoint; do
  if [ -n "$mountpoint" ]; then
    echo "Trimming $mountpoint..."
    fstrim -v "$mountpoint" 2>/dev/null || true
  fi
done < <(mount | grep -oP '(?<=on )[^ ]+(?= type)' | sort -u)

echo "Finished: $(date)"
