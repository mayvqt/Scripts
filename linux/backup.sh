#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo or run as root."
  exit 1
fi

BACKUP_ROOT="${BACKUP_ROOT:-/var/backups/sysadmin-scripts}"
STAMP="$(date '+%Y%m%d-%H%M%S')"
DEST="$BACKUP_ROOT/$STAMP"

mkdir -p "$DEST"
chmod 700 "$BACKUP_ROOT" "$DEST"

echo "== Server backup snapshot =="
echo "Destination: $DEST"

echo "Saving package inventory..."
dpkg-query -W -f='${binary:Package}\t${Version}\n' > "$DEST/packages.txt" 2>/dev/null || true
command -v snap >/dev/null 2>&1 && snap list > "$DEST/snaps.txt" 2>/dev/null || true
command -v flatpak >/dev/null 2>&1 && flatpak list > "$DEST/flatpaks.txt" 2>/dev/null || true

echo "Saving service and timer inventory..."
systemctl list-unit-files --type=service --no-pager > "$DEST/services.txt" 2>/dev/null || true
systemctl list-timers --all --no-pager > "$DEST/timers.txt" 2>/dev/null || true

echo "Archiving key configuration directories..."
tar --warning=no-file-changed --ignore-failed-read -czf "$DEST/etc.tar.gz" /etc 2>/dev/null || true

for dir in /opt /srv /var/www; do
  if [ -d "$dir" ]; then
    name="$(basename "$dir")"
    echo "Archiving $dir..."
    tar --warning=no-file-changed --ignore-failed-read -czf "$DEST/$name.tar.gz" "$dir" 2>/dev/null || true
  fi
done

if command -v docker >/dev/null 2>&1; then
  echo "Saving Docker inventory..."
  docker ps -a > "$DEST/docker-containers.txt" 2>/dev/null || true
  docker images > "$DEST/docker-images.txt" 2>/dev/null || true
  docker volume ls > "$DEST/docker-volumes.txt" 2>/dev/null || true
fi

echo "Creating checksum manifest..."
(cd "$DEST" && sha256sum * > SHA256SUMS 2>/dev/null || true)

echo "Backup snapshot completed: $DEST"
