# Maintenance Scripts

Cross-platform maintenance scripts with short names. The repo is organized around two ideas:

- **Routine actions** are safe to run regularly: update, clean, logs, disk, health, security, network, backup.
- **Repair actions** are opt-in: repair and netfix can change system state more aggressively and should be run when something is broken.

## Quick Start

Use the launcher when you want the shortest command. On Linux and macOS it auto-detects the platform:

```bash
maintenance/run.sh health
maintenance/run.sh network
sudo maintenance/run.sh all
sudo maintenance/run.sh repair
```

On Windows:

```cmd
maintenance\run.bat health
maintenance\run.bat network
maintenance\run.bat all
maintenance\run.bat repair
```

You can also run scripts directly from each platform folder.

## Action Guide

| Action | Purpose | Notes |
| --- | --- | --- |
| `all` | Run the main routine maintenance flow | Does not run repair scripts |
| `update` | Install OS and package updates | Linux targets apt-based systems |
| `clean` | Remove temp files and package caches | Conservative age-based cleanup |
| `logs` | Clean old logs or log archives | Some platforms require admin/root |
| `disk` | Disk usage, trim/optimize, read-only checks | Does not force offline repairs |
| `health` | System health report | Read-only |
| `security` | Security posture report | Read-only |
| `network` | Network report | Read-only |
| `backup` | Configuration snapshot | Not a full bare-metal backup |
| `repair` | Package/component/file integrity repair | Opt-in; admin/root recommended |
| `netfix` | DNS/network stack repair | May interrupt networking |

## Linux

Path: `maintenance/linux`

```text
all.sh        Run routine Linux maintenance
update.sh     apt update, upgrade, autoremove, autoclean
clean.sh      Clean apt cache, temp files, optional Docker prune
logs.sh       Vacuum journal and old rotated logs
disk.sh       Trim filesystems, report disk usage and large files
memory.sh     Drop caches and tune temporary memory sysctls
health.sh     Read-only system health report
security.sh   Read-only security and SSH posture report
network.sh    Read-only network report
users.sh      User, sudo/admin, and SSH key audit
backup.sh     Snapshot packages, services, /etc, /opt, /srv, /var/www
repair.sh     Repair dpkg/apt state, reset failed systemd units, verify journal
netfix.sh     Flush DNS/neighbor cache; optionally restart network services
docker.sh     Docker disk and container report; optional prune
services.sh   Disable selected optional services
portainer.sh  Upgrade/recreate Portainer container
amp.sh        Upgrade AMP as the amp user
```

Examples:

```bash
sudo maintenance/linux/all.sh
maintenance/linux/health.sh
maintenance/linux/security.sh
sudo maintenance/linux/backup.sh
sudo maintenance/linux/repair.sh
sudo maintenance/linux/netfix.sh
RESTART_NETWORK=1 sudo maintenance/linux/netfix.sh
maintenance/linux/docker.sh
PRUNE=1 maintenance/linux/docker.sh
DRY_RUN=1 sudo maintenance/linux/services.sh
```

Linux environment overrides:

- `BACKUP_ROOT=/path`: change backup destination for `backup.sh`.
- `PRUNE=1`: let `docker.sh` run `docker system prune -f`.
- `RESTART_NETWORK=1`: let `netfix.sh` restart network services.
- `DRY_RUN=1`: preview `services.sh` without disabling services.
- `HTTP_PORT=9001 EDGE_PORT=8001`: change `portainer.sh` published ports.

## macOS

Path: `maintenance/macos`

```text
all.sh       Run routine macOS maintenance
update.sh    Apple software update check/install and Homebrew update
clean.sh     Clean old user caches, temp files, Trash, Homebrew cache
logs.sh      Clean old system diagnostic and archived logs
disk.sh      Verify root volume and report disk/cache state
health.sh    Read-only system health report
security.sh  Read-only firewall, FileVault, Gatekeeper, admin report
network.sh   Read-only network report
backup.sh    Snapshot system profile, launch items, Brewfile, /etc
repair.sh    Disk repair when run with sudo, plus Homebrew health checks
netfix.sh    Flush DNS cache and renew DHCP leases
```

Examples:

```bash
maintenance/macos/all.sh
maintenance/macos/health.sh
maintenance/macos/security.sh
maintenance/macos/backup.sh
sudo maintenance/macos/logs.sh
sudo maintenance/macos/repair.sh
maintenance/macos/netfix.sh
```

macOS environment overrides:

- `BACKUP_ROOT=/path`: change backup destination for `backup.sh`.

## Windows

Path: `maintenance\windows`

```text
all.bat          Run routine Windows maintenance
update.bat       Windows Update scan/install
clean.bat        Temp cleanup, recycle bin, component cleanup
logs.bat         Clear event logs and old diagnostic logs
disk.bat         Optimize volumes and run read-only chkdsk scans
performance.bat  Conservative performance cleanup
health.bat       Read-only system health report
security.bat     Read-only firewall, Defender, admin, port report
network.bat      Read-only network report
backup.bat       Snapshot systeminfo, drivers, services, tasks, firewall policy
repair.bat       DISM RestoreHealth, SFC, and online disk scans
netfix.bat       Flush DNS, renew DHCP, reset Winsock/IP stack
services.bat     Disable selected optional services
```

Examples:

```cmd
maintenance\windows\all.bat
maintenance\windows\health.bat
maintenance\windows\security.bat
maintenance\windows\backup.bat
maintenance\windows\repair.bat
maintenance\windows\netfix.bat
```

Windows notes:

- Run from an elevated Command Prompt or PowerShell session for full results.
- `BACKUP_ROOT=C:\path`: change backup destination for `backup.bat`.
- `repair.bat` can take a while because DISM and SFC are thorough.
- `netfix.bat` may require a restart after resetting Winsock and IP state.

## Safety Notes

- The `all` scripts intentionally skip `repair` and `netfix`.
- The diagnostic scripts are designed to be read-only: `health`, `security`, `network`, and `users`.
- Repair scripts can change package state, reset services, repair components, or reset networking.
- Backup scripts create configuration snapshots for recovery notes; they are not full image backups.
- Review `services` scripts before running them on shared, managed, or production machines.
- Keep real backups before running repair work on important systems.
