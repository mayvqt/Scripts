#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

run_script() {
  local script="$1"
  printf '\n---- Running %s ----\n' "$script"
  "$SCRIPT_DIR/$script"
}

run_script update.sh
run_script clean.sh

if [ "$(id -u)" -eq 0 ]; then
  run_script logs.sh
else
  echo "Skipping logs.sh; run all.sh with sudo to clean system logs."
fi

run_script disk.sh
run_script security.sh
run_script health.sh

echo
echo "macOS full maintenance completed."
