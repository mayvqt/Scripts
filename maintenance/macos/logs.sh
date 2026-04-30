#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(dscl . -read "/Users/$TARGET_USER" NFSHomeDirectory 2>/dev/null | awk '{print $2}')"
TARGET_HOME="${TARGET_HOME:-$HOME}"

log "== Maintenance: macOS log cleanup =="

log "Removing old diagnostic and crash reports..."
find /Library/Logs/DiagnosticReports "$TARGET_HOME/Library/Logs/DiagnosticReports" -type f -mtime +30 -delete 2>/dev/null || true

log "Removing archived logs older than 60 days..."
find /Library/Logs -type f \( -name "*.gz" -o -name "*.old" -o -name "*.log.*" \) -mtime +60 -delete 2>/dev/null || true

log "Largest remaining logs:"
find /Library/Logs -type f -size +50M -print 2>/dev/null | head -20 || true

log "Finished macOS log cleanup."
