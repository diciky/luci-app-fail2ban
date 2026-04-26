# luci-app-fail2ban

Fail2ban LuCI Interface for OpenWrt

## Features

- **Status**: View fail2ban service status and SSH jail info
- **Configuration**: Configure ban time, find time, max retry, log level
- **Banned IPs**: View and unban blocked IP addresses
- **Log**: View fail2ban log in real-time

## Requirements

- OpenWrt 21.02+ or LEDE 17.01+
- fail2ban installed
- luci-base

## Installation

### Method 1: Build from source

```bash
# Clone to OpenWrt package directory
cd openwrt/package
git clone https://github.com/diciky/luci-app-fail2ban.git

# Build
cd openwrt
make menuconfig  # Select LuCI > Applications > luci-app-fail2ban
make package/luci-app-fail2ban/compile
```

### Method 2: Manual installation

Copy files to your OpenWrt router:

```bash
# Copy config
scp -P 38438 etc/config/fail2ban root@10.10.10.254:/etc/config/fail2ban

# Copy controller
scp -P 38438 usr/lib/lua/luci/controller/fail2ban.lua root@10.10.10.254:/usr/lib/lua/luci/controller/fail2ban.lua

# Copy views
scp -P 38438 -r usr/lib/lua/luci/view/fail2ban root@10.10.10.254:/usr/lib/lua/luci/view/fail2ban

# Set permissions
ssh -p 38438 root@10.10.10.254 "chmod 644 /usr/lib/lua/luci/controller/fail2ban.lua"
ssh -p 38438 root@10.10.10.254 "chmod 644 /usr/lib/lua/luci/view/fail2ban/*.htm"

# Restart LuCI
ssh -p 38438 root@10.10.10.254 "/etc/init.d/luci reload"
```

## Access

After installation, access via LuCI web interface:

```
http://10.10.10.254 → Services → Fail2ban
```

## Screenshots

### Status Page
- Service running status
- SSH jail statistics
- Quick actions (Start/Stop/Reload)

### Banned IPs Page
- List all banned IP addresses
- One-click unban individual IP
- Unban all IPs at once

### Configuration Page
- Enable/Disable fail2ban
- Configure ban time (default: 24 hours)
- Configure find time (default: 10 minutes)
- Configure max retry (default: 5 attempts)
- Log level settings

## License

GPL-3.0
