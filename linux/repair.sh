#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

section() {
  printf '\n== %s ==\n' "$1"
}

section "Package State"
if command -v dpkg >/dev/null 2>&1; then
  dpkg --configure -a
fi

if command -v apt-get >/dev/null 2>&1; then
  apt-get -f install -y
  apt-get update
  apt-get check
fi

section "Systemd State"
if command -v systemctl >/dev/null 2>&1; then
  systemctl daemon-reload
  systemctl reset-failed
  systemctl --failed --no-pager || true
fi

section "Journal Integrity"
if command -v journalctl >/dev/null 2>&1; then
  journalctl --verify || true
fi

section "Filesystem Report"
df -hT
findmnt -rn -o TARGET,FSTYPE,OPTIONS | sed -n '1,80p'

section "Kernel Warnings"
dmesg --level=err,warn --ctime 2>/dev/null | tail -80 || true

echo
echo "Repair pass completed. Filesystem repairs for mounted disks are not forced here; boot from rescue media or schedule offline fsck when needed."
