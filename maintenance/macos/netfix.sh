#!/usr/bin/env bash
set -euo pipefail

echo "== Network repair =="

echo "Flushing DNS cache..."
dscacheutil -flushcache 2>/dev/null || true
killall -HUP mDNSResponder 2>/dev/null || true

echo "Renewing DHCP leases for active services..."
while IFS= read -r service; do
  [ -n "$service" ] || continue
  networksetup -renewdhcp "$service" 2>/dev/null || true
done < <(networksetup -listallnetworkservices 2>/dev/null | sed '1d; s/^\*//')

echo
echo "Connectivity check:"
ping -c 3 1.1.1.1 || true
ping -c 3 apple.com || true
