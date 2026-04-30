#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

echo "== Maintenance: cleanup logs and journal =="
echo "Started: $(date)"

if command -v journalctl >/dev/null 2>&1; then
  log "Vacuuming systemd journal to 200M and 14 days..."
  journalctl --vacuum-size=200M || true
  journalctl --vacuum-time=14d || true
fi

log "Removing old rotated logs..."
find /var/log -type f \( -name "*.gz" -o -name "*.old" -o -name "*.1" -o -name "*.1.gz" \) -mtime +90 -delete || true

log "Truncating oversized text logs..."
find /var/log -type f \( -name "*.log" -o -name "syslog" -o -name "messages" \) -size +200M -exec truncate -s 100M {} \; || true

log "Largest remaining logs:"
find /var/log -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -10 | awk '{printf "%.1fM %s\n", $1/1048576, $2}' || true

echo "Finished: $(date)"
