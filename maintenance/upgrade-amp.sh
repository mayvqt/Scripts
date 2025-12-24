#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo."
  exit 1
fi

if ! id -u amp >/dev/null 2>&1; then
  echo "User 'amp' does not exist on this system. Aborting."
  exit 1
fi

echo "== Maintenance: AMP Panel upgrade =="
echo "Running as: $(date)"

# Run ampinstmgr upgradeall as the 'amp' user. Use runuser for non-interactive execution.
runuser -l amp -c 'if command -v ampinstmgr >/dev/null 2>&1; then ampinstmgr upgradeall; else echo "ampinstmgr not found in PATH for user amp"; exit 2; fi'

echo "AMP upgrade completed."
