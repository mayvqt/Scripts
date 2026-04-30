#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "Security Updates"
if command -v apt-get >/dev/null 2>&1; then
  apt-get -s upgrade 2>/dev/null | awk '/^Inst/ && /security/ {print}' || true
fi

section "Firewall"
if command -v ufw >/dev/null 2>&1; then
  ufw status verbose || true
elif command -v firewall-cmd >/dev/null 2>&1; then
  firewall-cmd --list-all || true
else
  iptables -S 2>/dev/null || true
fi

section "SSH Configuration"
if [ -f /etc/ssh/sshd_config ]; then
  sshd -T 2>/dev/null | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|port|allowusers|allowgroups)' || true
fi

section "Failed Login Activity"
lastb -a | head -20 2>/dev/null || true
journalctl -u ssh -u sshd --since "24 hours ago" --no-pager 2>/dev/null | grep -Ei 'failed|invalid|authentication failure' | tail -30 || true

section "Accounts With Login Shells"
awk -F: '$7 !~ /(nologin|false)$/ {printf "%-24s %-8s %s\n", $1, $3, $7}' /etc/passwd

section "SUID Files Outside System Paths"
find / -xdev -perm -4000 -type f 2>/dev/null | grep -Ev '^/(bin|sbin|usr/bin|usr/sbin|usr/lib|snap)/' || true

section "Listening Services"
ss -tulpn 2>/dev/null || true
