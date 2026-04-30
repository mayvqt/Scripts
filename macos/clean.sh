#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "== Maintenance: macOS cleanup =="

log "Cleaning user caches older than 14 days..."
find "$HOME/Library/Caches" -mindepth 1 -mtime +14 -exec rm -rf {} + 2>/dev/null || true

log "Cleaning temporary files older than 7 days..."
find /tmp -mindepth 1 -mtime +7 -exec rm -rf {} + 2>/dev/null || true

if command -v brew >/dev/null 2>&1; then
  log "Cleaning Homebrew cache..."
  brew cleanup --prune=all || true
fi

log "Emptying current user's Trash..."
rm -rf "$HOME/.Trash/"* 2>/dev/null || true

log "Disk usage:"
df -h /

log "Finished macOS cleanup."
