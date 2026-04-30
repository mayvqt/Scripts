#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-$HOME/sysadmin-script-backups}"
STAMP="$(date '+%Y%m%d-%H%M%S')"
DEST="$BACKUP_ROOT/$STAMP"

mkdir -p "$DEST"
chmod 700 "$BACKUP_ROOT" "$DEST"

echo "== macOS configuration snapshot =="
echo "Destination: $DEST"

echo "Saving system profile summary..."
system_profiler SPSoftwareDataType SPHardwareDataType > "$DEST/system-profile.txt" 2>/dev/null || true

echo "Saving launch daemon and agent inventory..."
launchctl list > "$DEST/launchctl-list.txt" 2>/dev/null || true
find /Library/LaunchDaemons /Library/LaunchAgents "$HOME/Library/LaunchAgents" -maxdepth 1 -type f -print > "$DEST/launch-items.txt" 2>/dev/null || true

if command -v brew >/dev/null 2>&1; then
  echo "Saving Homebrew bundle..."
  brew bundle dump --file="$DEST/Brewfile" --force 2>/dev/null || true
fi

echo "Archiving key configuration folders..."
tar -czf "$DEST/etc.tar.gz" /etc 2>/dev/null || true

echo "Creating checksum manifest..."
(cd "$DEST" && shasum -a 256 * > SHA256SUMS 2>/dev/null || true)

echo "Backup snapshot completed: $DEST"
