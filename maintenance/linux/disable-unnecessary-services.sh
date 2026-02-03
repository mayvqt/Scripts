#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Optimization: Disable unnecessary services ==="
echo "Started: $(date)"

# List of commonly unnecessary services (modify based on your environment)
SERVICES_TO_DISABLE=(
  "avahi-daemon"
  "cups"
  "bluetooth"
  "iscsid"
  "nfs-client"
)

echo "Checking for unnecessary services..."
for service in "${SERVICES_TO_DISABLE[@]}"; do
  if systemctl list-unit-files | grep -q "^$service"; then
    echo "Disabling $service..."
    systemctl disable "$service" 2>/dev/null || true
    systemctl stop "$service" 2>/dev/null || true
  fi
done

echo "Finished: $(date)"
