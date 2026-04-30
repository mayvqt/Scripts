#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get was not found. This script supports Debian/Ubuntu based systems."
  exit 2
fi

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "== Maintenance: apt update and upgrade =="
echo "Started: $(date)"

if command -v dpkg >/dev/null 2>&1; then
  log "Configuring any interrupted package operations..."
  dpkg --configure -a
fi

log "Refreshing package lists..."
apt-get update

log "Installing available package upgrades..."
apt-get -y upgrade

log "Removing unused packages and cleaning package cache..."
apt-get -y autoremove
apt-get -y autoclean

if [ -f /var/run/reboot-required ]; then
  log "A reboot is required to finish applying updates."
fi

echo "Finished: $(date)"
