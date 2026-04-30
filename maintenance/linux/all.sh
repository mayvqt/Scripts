#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

run_script() {
  local script="$1"
  printf '\n---- Running %s ----\n' "$script"
  "$SCRIPT_DIR/$script"
}

run_script update.sh
run_script clean.sh
run_script logs.sh
run_script disk.sh
run_script security.sh
run_script health.sh

echo
echo "Linux full maintenance completed."
