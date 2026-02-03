#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Maintenance: System health check and diagnostics =="
echo "Started: $(date)"

echo ""
echo "=== Disk Usage ==="
df -h / | tail -n 1

echo ""
echo "=== Memory Usage ==="
free -h | grep Mem

echo ""
echo "=== Top CPU Processes ==="
ps aux --sort=-%cpu | head -n 6

echo ""
echo "=== Top Memory Processes ==="
ps aux --sort=-%mem | head -n 6

echo ""
echo "=== System Load ==="
uptime

echo ""
echo "=== Open Ports ==="
ss -tlnp 2>/dev/null | grep LISTEN || netstat -tlnp 2>/dev/null | grep LISTEN || true

echo ""
echo "=== Failed Services (if any) ==="
systemctl --failed 2>/dev/null || echo "No failed services"

echo ""
echo "=== Recent Kernel Messages ==="
dmesg | tail -n 10

echo ""
echo "Finished: $(date)"
