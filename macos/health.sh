#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "System"
sw_vers
hostname
uptime

section "Hardware"
system_profiler SPHardwareDataType | sed -n '1,30p'

section "Disk"
df -h
diskutil list

section "Memory"
vm_stat

section "Top Processes"
ps -arcwwwxo pid,comm,%cpu,%mem | head -15

section "Network Listeners"
lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null || true

section "Recent System Errors"
log show --last 1h --predicate 'eventType == logEvent AND messageType == error' --style compact 2>/dev/null | tail -50 || true
