#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "Disk Repair"
if [ "$(id -u)" -eq 0 ]; then
  diskutil repairVolume / || true
else
  diskutil verifyVolume / || true
  echo "Run with sudo to attempt diskutil repairVolume /."
fi

section "Software Update State"
softwareupdate --list || true

section "Homebrew Health"
if command -v brew >/dev/null 2>&1 && [ "$(id -u)" -ne 0 ]; then
  brew doctor || true
  brew missing || true
elif [ "$(id -u)" -eq 0 ]; then
  echo "Skipping Homebrew checks while running as root."
else
  echo "Homebrew not found."
fi

section "Launch Services"
if [ "$(id -u)" -eq 0 ]; then
  launchctl print system >/dev/null 2>&1 || true
fi

echo
echo "Repair pass completed."
