#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "== Maintenance: macOS updates =="

log "Checking Apple software updates..."
softwareupdate --list || true
if [ "$(id -u)" -eq 0 ]; then
  softwareupdate --install --all --agree-to-license || true
else
  log "Run with sudo to install Apple software updates."
fi

if [ "$(id -u)" -ne 0 ] && command -v brew >/dev/null 2>&1; then
  log "Updating Homebrew packages..."
  brew update
  brew upgrade
  brew cleanup --prune=all
elif [ "$(id -u)" -eq 0 ]; then
  log "Skipping Homebrew while running as root."
else
  log "Homebrew not found; skipping brew update."
fi

log "Finished macOS update maintenance."
