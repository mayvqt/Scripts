# Cross-Platform Admin Scripts

Short, practical scripts for routine server and workstation care. The repo is organized directly by platform:

```text
.
├── run.sh
├── run.bat
├── linux/
├── macos/
└── windows/
```

Routine actions handle updates, cleanup, logs, backups, and reports. Repair actions are separate and opt-in.

## Quick Start

On Linux and macOS, `run.sh` auto-detects the platform:

```bash
./run.sh health
./run.sh network
sudo ./run.sh all
sudo ./run.sh repair
```

On Windows:

```cmd
run.bat health
run.bat network
run.bat all
run.bat repair
```

You can also run scripts directly from `linux/`, `macos/`, or `windows/`.

## Actions

| Action | Purpose | Risk |
| --- | --- | --- |
| `all` | Run the main routine flow | Routine |
| `update` | Install OS and package updates | Routine |
| `clean` | Remove temp files and package caches | Routine |
| `logs` | Clean old logs or log archives | Routine |
| `disk` | Disk usage, trim/optimize, read-only checks | Routine |
| `health` | System health report | Read-only |
| `security` | Security posture report | Read-only |
| `network` | Network report | Read-only |
| `backup` | Configuration snapshot | Routine |
| `repair` | Package/component/file integrity repair | Opt-in |
| `netfix` | DNS/network stack repair | Opt-in |

The `all` scripts intentionally skip `repair` and `netfix`.

## Linux

```text
linux/
├── all.sh
├── amp.sh
├── backup.sh
├── clean.sh
├── disk.sh
├── docker.sh
├── health.sh
├── logs.sh
├── memory.sh
├── netfix.sh
├── network.sh
├── portainer.sh
├── repair.sh
├── security.sh
├── services.sh
├── update.sh
└── users.sh
```

Examples:

```bash
sudo linux/all.sh
linux/health.sh
linux/security.sh
sudo linux/backup.sh
sudo linux/repair.sh
sudo linux/netfix.sh
RESTART_NETWORK=1 sudo linux/netfix.sh
linux/docker.sh
PRUNE=1 linux/docker.sh
DRY_RUN=1 sudo linux/services.sh
```

Linux notes:

- `update.sh`: apt update, upgrade, autoremove, autoclean.
- `backup.sh`: snapshots packages, services, `/etc`, `/opt`, `/srv`, and `/var/www`.
- `repair.sh`: repairs dpkg/apt state, resets failed systemd units, verifies journal health.
- `netfix.sh`: flushes DNS and neighbor caches. Set `RESTART_NETWORK=1` to restart network services.
- `docker.sh`: reports Docker usage. Set `PRUNE=1` to run `docker system prune -f`.
- `services.sh`: set `DRY_RUN=1` to preview service changes.
- `portainer.sh`: supports `HTTP_PORT` and `EDGE_PORT` overrides.
- Backup default: `/var/backups/sysadmin-scripts`.

## macOS

```text
macos/
├── all.sh
├── backup.sh
├── clean.sh
├── disk.sh
├── health.sh
├── logs.sh
├── netfix.sh
├── network.sh
├── repair.sh
├── security.sh
└── update.sh
```

Examples:

```bash
macos/all.sh
macos/health.sh
macos/security.sh
macos/backup.sh
sudo macos/logs.sh
sudo macos/repair.sh
macos/netfix.sh
```

macOS notes:

- `update.sh`: Apple software update check/install and Homebrew update.
- `backup.sh`: snapshots system profile, launch items, Brewfile, and `/etc`.
- `repair.sh`: verifies or repairs the root volume and runs Homebrew health checks.
- `netfix.sh`: flushes DNS and renews DHCP leases.
- Backup default: `$HOME/sysadmin-script-backups`.

## Windows

```text
windows\
├── all.bat
├── backup.bat
├── clean.bat
├── disk.bat
├── health.bat
├── logs.bat
├── netfix.bat
├── network.bat
├── performance.bat
├── repair.bat
├── security.bat
├── services.bat
└── update.bat
```

Examples:

```cmd
windows\all.bat
windows\health.bat
windows\security.bat
windows\backup.bat
windows\repair.bat
windows\netfix.bat
```

Windows notes:

- Run from an elevated Command Prompt or PowerShell session for full results.
- `backup.bat`: snapshots systeminfo, drivers, services, scheduled tasks, and firewall policy.
- `repair.bat`: runs DISM RestoreHealth, SFC, and online disk scans.
- `netfix.bat`: flushes DNS, renews DHCP, and resets Winsock/IP state.
- `disk.bat`: optimizes volumes and runs read-only chkdsk scans.
- Backup default: `%SystemDrive%\sysadmin-script-backups`.

## Safety

- `health`, `security`, `network`, and `users` are designed as read-only diagnostics.
- `repair` and `netfix` are opt-in because they can change package state, reset services, repair components, or reset networking.
- Backup scripts create configuration snapshots for recovery notes. They are not full image backups.
- Review `services` scripts before running them on shared, managed, or production machines.
- Keep real backups before running repair work on important systems.
