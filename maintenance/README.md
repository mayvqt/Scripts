# maintenance

- `cleanup-logs.sh`: vacuum systemd journal, delete old rotated logs, truncate huge logs.
- `cleanup.sh`: remove apt lists and clean `/tmp` and `/var/tmp`.
- `update-upgrade.sh`: run `apt-get update` + `upgrade`, then `autoremove`/`autoclean`.
- `upgrade-amp.sh`: run `ampinstmgr upgradeall` as user `amp` (requires `amp` user).
- `upgrade-portainer.sh`: pull latest Portainer CE image and run the container (uses Docker).

Run scripts with `sudo` or as root when required.
