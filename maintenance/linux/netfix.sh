#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

RESTART_NETWORK="${RESTART_NETWORK:-0}"

echo "== Network repair =="

echo "Flushing resolver caches..."
resolvectl flush-caches 2>/dev/null || true
nscd -i hosts 2>/dev/null || true

echo "Flushing stale neighbor cache..."
ip neigh flush all 2>/dev/null || true

if [ "$RESTART_NETWORK" = "1" ]; then
  echo "Restarting network services..."
  systemctl restart systemd-resolved 2>/dev/null || true
  systemctl restart NetworkManager 2>/dev/null || true
  systemctl restart networking 2>/dev/null || true
else
  echo "Skipping network service restarts. Set RESTART_NETWORK=1 to restart network services."
fi

echo
echo "Connectivity check:"
ping -c 3 1.1.1.1 || true
ping -c 3 google.com || true
