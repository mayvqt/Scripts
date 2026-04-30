#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ACTION="${1:-health}"

case "$(uname -s)" in
  Linux) PLATFORM="linux" ;;
  Darwin) PLATFORM="macos" ;;
  *)
    echo "Unsupported platform: $(uname -s)"
    exit 2
    ;;
esac

TARGET="$SCRIPT_DIR/$PLATFORM/$ACTION.sh"

if [ ! -x "$TARGET" ]; then
  echo "Unknown action '$ACTION' for $PLATFORM."
  echo "Available actions:"
  for script in "$SCRIPT_DIR/$PLATFORM"/*.sh; do
    [ -e "$script" ] || continue
    name="$(basename "$script" .sh)"
    printf '  %s\n' "$name"
  done | sort
  exit 2
fi

shift || true
exec "$TARGET" "$@"
