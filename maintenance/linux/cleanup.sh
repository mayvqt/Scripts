#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Maintenance: cleanup temporary files and apt lists =="
echo "Started: $(date)"

# Remove cached apt lists (will be refetched on next update)
rm -rf /var/lib/apt/lists/* || true

# Remove old /tmp dirs (7+ days) and older files in /var/tmp
find /tmp -mindepth 1 -maxdepth 1 -type d -mtime +7 -exec rm -rf {} + || true
find /var/tmp -type f -mtime +30 -delete || true

echo "Finished: $(date)"
