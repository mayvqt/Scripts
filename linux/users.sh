#!/usr/bin/env bash
set -euo pipefail

echo "== User and privilege audit =="

echo
echo "Accounts with interactive shells:"
awk -F: '$7 !~ /(nologin|false)$/ {printf "%-24s uid=%-8s home=%-30s shell=%s\n", $1, $3, $6, $7}' /etc/passwd

echo
echo "Members of sudo/admin/wheel groups:"
getent group sudo admin wheel 2>/dev/null || true

echo
echo "Users with authorized SSH keys:"
find /home /root -path '*/.ssh/authorized_keys' -type f -printf '%p\n' 2>/dev/null || true

echo
echo "Recent logins:"
last -a | head -30 || true
