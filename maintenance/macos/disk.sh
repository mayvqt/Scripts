#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "== Optimization: macOS disk maintenance =="

log "Disk usage:"
df -h /

log "APFS volume information:"
diskutil apfs list 2>/dev/null || diskutil list

log "Verifying root volume..."
diskutil verifyVolume / || true

log "Finding large cache files..."
find "$HOME/Library/Caches" -type f -size +250M -print 2>/dev/null | head -30 || true

log "Finished macOS disk maintenance."
