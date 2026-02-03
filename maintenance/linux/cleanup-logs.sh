#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Maintenance: cleanup logs and journal =="
echo "Started: $(date)"

# Reduce systemd journal size and retention
journalctl --vacuum-size=200M || true
journalctl --vacuum-time=7d || true

# Remove archived rotated logs older than 90 days
find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.1" -o -name "*.1.gz" \) -mtime +90 -delete || true

# Truncate very large logs (>200M) to 100M to keep disk space
find /var/log -type f -size +200M -exec truncate -s 100M {} \; || true

echo "Finished: $(date)"
