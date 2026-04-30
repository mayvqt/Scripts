#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "Interfaces"
ip -brief address || true

section "Routes"
ip route || true

section "DNS"
cat /etc/resolv.conf
command -v resolvectl >/dev/null 2>&1 && resolvectl status 2>/dev/null | sed -n '1,80p'

section "Connectivity"
ping -c 3 1.1.1.1 || true
ping -c 3 google.com || true

section "Listening Ports"
ss -tulpn || true

section "Established Connections"
ss -tun state established | head -50 || true
