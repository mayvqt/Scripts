#!/usr/bin/env bash
set -euo pipefail

section() {
  printf '\n== %s ==\n' "$1"
}

section "Gatekeeper And System Integrity"
spctl --status || true
csrutil status 2>/dev/null || true

section "Firewall"
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || true
/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>/dev/null || true

section "FileVault"
fdesetup status 2>/dev/null || true

section "Remote Access"
systemsetup -getremotelogin 2>/dev/null || true
launchctl print-disabled system 2>/dev/null | grep -E 'ssh|screensharing|ard' || true

section "Admin Users"
dscl . -read /Groups/admin GroupMembership 2>/dev/null || true

section "Recent Auth Failures"
log show --last 24h --predicate 'eventMessage CONTAINS[c] "authentication failed" OR eventMessage CONTAINS[c] "Failed to authenticate"' --style compact 2>/dev/null | tail -40 || true
