#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "System"
hostnamectl 2>/dev/null || uname -a
uptime || true

section "CPU And Memory"
command -v lscpu >/dev/null 2>&1 && lscpu | sed -n '1,12p'
free -h || true

section "Disk"
df -hT
command -v lsblk >/dev/null 2>&1 && lsblk -f

section "Top Processes"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -11

section "Network Listeners"
if command -v ss >/dev/null 2>&1; then
  ss -tulpn
else
  netstat -tulpn 2>/dev/null || true
fi

section "Failed Services"
if command -v systemctl >/dev/null 2>&1; then
  systemctl --failed --no-pager || true
fi

section "Recent Kernel Messages"
dmesg --level=err,warn --ctime 2>/dev/null | tail -50 || true
