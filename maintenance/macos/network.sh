#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "Interfaces"
ifconfig | sed -n '1,160p'

section "Routes"
netstat -rn

section "DNS"
scutil --dns | sed -n '1,120p'

section "Connectivity"
ping -c 3 1.1.1.1 || true
ping -c 3 apple.com || true

section "Listening Ports"
lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null || true
