# Maintenance Scripts Organization

This directory contains maintenance, optimization, and diagnostics scripts organized by operating system.

## Directory Structure

```
maintenance/
├── linux/
│   ├── cleanup-logs.sh                  # Clean system logs and journals
│   ├── cleanup.sh                       # Clean temporary files and apt cache
│   ├── update-upgrade.sh                # Update packages and perform upgrades
│   ├── optimize-memory.sh               # Memory and cache optimization
│   ├── optimize-disk.sh                 # Disk and filesystem optimization
│   ├── system-health-check.sh           # System diagnostics and monitoring
│   └── disable-unnecessary-services.sh  # Disable non-essential services
│
└── windows/
    ├── cleanup-logs.bat                 # Clean Windows Event Logs and temp files
    ├── cleanup.bat                      # Clean temporary files
    ├── update-upgrade.bat               # Check and install Windows updates
    ├── system-health-check.bat          # System diagnostics and monitoring
    ├── disable-unnecessary-services.bat # Disable non-essential services
    ├── optimize-performance.bat         # Performance optimization
    └── optimize-disk.bat                # Disk optimization and cleanup
```

## Linux Scripts

All Linux scripts require **root/sudo** privileges and are written in Bash.

### cleanup-logs.sh
- Manages systemd journal (reduces size to 200M, retention 7 days)
- Removes archived logs older than 90 days
- Truncates large logs (>200M) to 100M

### cleanup.sh
- Removes cached apt package lists
- Cleans old temporary directories (7+ days)
- Removes old files in `/var/tmp` (30+ days)

### update-upgrade.sh
- Runs `apt-get update` to refresh package lists
- Performs `apt-get upgrade` for safe package upgrades
- Runs `apt-get autoremove` and `apt-get autoclean`

### optimize-memory.sh
- Clears page cache, dentries, and inodes
- Sets swappiness to 10 (prefer RAM over swap)
- Optimizes inode cache based on system memory
- Tunes network stack for efficiency

### optimize-disk.sh
- Defragments ext4 filesystems
- Checks and optimizes mount options
- Cleans up orphaned files
- Trims SSD for better performance

### system-health-check.sh
- Displays disk usage statistics
- Shows memory usage and allocation
- Lists top CPU and memory consuming processes
- Reports system load and uptime
- Displays open network ports
- Lists failed systemd services
- Shows recent kernel messages

### disable-unnecessary-services.sh
- Disables common non-essential services (avahi-daemon, cups, bluetooth, etc.)
- Safe to customize based on your environment

## Windows Scripts

All Windows scripts require **Administrator** privileges.

### cleanup-logs.bat
- Clears Windows Event Logs
- Cleans `%TEMP%` and system temp directories
- Runs Windows Disk Cleanup utility

### cleanup.bat
- Cleans user temporary files
- Clears system temporary files
- Removes internet temporary files
- Clears recent files
- Empties Recycle Bin

### update-upgrade.bat
- Starts Windows Update service
- Checks for and installs available Windows updates
- Note: Requires PowerShell Windows Update module for full functionality

### system-health-check.bat
- Displays disk usage and free space
- Shows memory statistics
- Reports system uptime and boot time
- Lists running processes and services
- Shows network connection count
- Displays Event Log summary
- Reports service status

### disable-unnecessary-services.bat
- Disables Bluetooth service
- Disables DiagTrack and telemetry services
- Optional: Print Spooler, Windows Search (commented out)
- Safe to customize based on your needs

### optimize-performance.bat
- Optimizes visual effects for performance
- Clears DNS cache
- Tunes network settings (TCP autotune, ECN)
- Optimizes thumbnail cache
- Defragments virtual memory
- Clears font cache
- Sets power plan to High Performance

### optimize-disk.bat
- Analyzes disk fragmentation
- Defragments disk
- Clears Windows Update cache
- Removes installer cache
- Runs disk check (CHKDSK)
- Clears prefetch
- Compresses system files

## Usage

### Linux
```bash
# Cleanup operations
sudo /path/to/maintenance/linux/cleanup-logs.sh
sudo /path/to/maintenance/linux/cleanup.sh

# Updates
sudo /path/to/maintenance/linux/update-upgrade.sh

# Optimization
sudo /path/to/maintenance/linux/optimize-memory.sh
sudo /path/to/maintenance/linux/optimize-disk.sh
sudo /path/to/maintenance/linux/disable-unnecessary-services.sh

# Monitoring
sudo /path/to/maintenance/linux/system-health-check.sh
```

### Windows
```cmd
# Cleanup operations
C:\path\to\maintenance\windows\cleanup-logs.bat
C:\path\to\maintenance\windows\cleanup.bat

# Updates
C:\path\to\maintenance\windows\update-upgrade.bat

# Optimization
C:\path\to\maintenance\windows\optimize-performance.bat
C:\path\to\maintenance\windows\optimize-disk.bat
C:\path\to\maintenance\windows\disable-unnecessary-services.bat

# Monitoring
C:\path\to\maintenance\windows\system-health-check.bat
```

## Prerequisites

- **Linux**: Bash shell, standard Linux utilities (find, journalctl, systemctl, etc.)
- **Windows**: Windows CMD or PowerShell, Administrator privileges

## Notes

- All scripts include error checking and proper exit codes
- Temporary file cleanup scripts use safe deletion with error suppression
- Root/Administrator checks are performed at script start
- Optimization scripts are safe to run regularly
- Health check scripts are read-only and don't modify system state
- Customize service disable lists based on your specific environment
