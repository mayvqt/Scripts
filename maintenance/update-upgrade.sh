#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

echo "== Maintenance: apt update && upgrade =="
echo "Started: $(date)"

# Update package lists and perform safe upgrades
apt-get update
apt-get -y upgrade

# Cleanup packages
apt-get -y autoremove
apt-get -y autoclean

echo "Finished: $(date)"
