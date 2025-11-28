#!/bin/sh
################################################################################
# OPNsense Documentation Generator
#
# Dieses Script sammelt alle wichtigen Informationen von OPNsense für die Dokumentation
#
# Verwendung:
#   ssh root@opensence.mrz.ip 'sh' < generate-opnsense-documentation.sh > opnsense-export.md
#   oder
#   scp generate-opnsense-documentation.sh root@opensence.mrz.ip:/tmp/
#   ssh root@opensence.mrz.ip "/tmp/generate-opnsense-documentation.sh"
################################################################################

cat << 'HEADER'
# 🛡️ OPNsense Firewall Configuration Export

> Automatisch generiert am: $(date '+%Y-%m-%d %H:%M:%S')
> Host: $(hostname)
> Version: $(opnsense-version)

---

HEADER

echo "## 📊 System Information"
echo ""
echo "| Parameter | Wert |"
echo "|-----------|------|"
echo "| **Hostname** | $(hostname) |"
echo "| **OPNsense Version** | $(opnsense-version | head -1) |"
echo "| **Kernel** | $(uname -r) |"
echo "| **Uptime** | $(uptime | awk '{print $3, $4}' | sed 's/,//') |"
echo "| **CPU** | $(sysctl -n hw.model) |"
echo "| **Memory** | $(sysctl -n hw.physmem | awk '{print int($1/1024/1024/1024) " GB"}') |"
echo ""
echo "---"
echo ""

echo "## 🌐 Network Interfaces"
echo ""
echo "| Interface | IP Address | Status | Description |"
echo "|-----------|------------|--------|-------------|"
ifconfig | awk '
/^[a-z]/ {
    iface=$1;
    gsub(/:/, "", iface);
    status="";
    ip="";
}
/status:/ {
    status=$2;
}
/inet / {
    ip=$2;
}
/inet / && status != "" {
    printf "| %s | %s | %s | |\n", iface, ip, status;
    status="";
    ip="";
}'
echo ""
echo "---"
echo ""

echo "## 🔥 Firewall Rules"
echo ""
echo "### Active Rules Summary"
echo ""
pfctl -sr | head -20
echo ""
echo "_(Erste 20 Regeln)_"
echo ""
echo "---"
echo ""

echo "## 🛣️ Routing Table"
echo ""
echo "### IPv4 Routes"
echo '```'
netstat -rn -f inet | head -20
echo '```'
echo ""
echo "### IPv6 Routes"
echo '```'
netstat -rn -f inet6 | head -10
echo '```'
echo ""
echo "---"
echo ""

echo "## 📈 Interface Statistics"
echo ""
echo "| Interface | RX Packets | RX Bytes | TX Packets | TX Bytes |"
echo "|-----------|------------|----------|------------|----------|"
netstat -ibn | awk 'NR>1 && $1 !~ /lo/ {printf "| %s | %s | %s | %s | %s |\n", $1, $5, $6, $7, $8}' | head -10
echo ""
echo "---"
echo ""

echo "## 🔒 Active Connections"
echo ""
echo "### Connection Summary"
echo '```'
pfctl -si | grep -A 10 "State Table"
echo '```'
echo ""
echo "---"
echo ""

echo "## 📡 DHCP Leases (if available)"
echo ""
if [ -f /var/dhcpd/var/db/dhcpd.leases ]; then
    echo '```'
    grep -A 5 "lease " /var/dhcpd/var/db/dhcpd.leases | head -30
    echo '```'
else
    echo "_DHCP leases file not found_"
fi
echo ""
echo "---"
echo ""

echo "## 🌍 DNS Configuration"
echo ""
echo "### Resolver Configuration"
echo '```'
cat /etc/resolv.conf
echo '```'
echo ""
echo "---"
echo ""

echo "## 🔐 VPN Status (if configured)"
echo ""
if [ -f /var/etc/ipsec/ipsec.conf ]; then
    echo "### IPsec Configuration Present"
    echo '```'
    ipsec status
    echo '```'
else
    echo "_No IPsec configuration found_"
fi
echo ""
echo "---"
echo ""

echo "## 📊 System Load & Performance"
echo ""
echo "| Metric | Value |"
echo "|--------|-------|"
echo "| **Load Average** | $(uptime | awk -F'load average:' '{print $2}') |"
echo "| **CPU Usage** | $(top -d 1 | grep "CPU:" | head -1) |"
echo "| **Memory Usage** | $(top -d 1 | grep "Mem:" | head -1) |"
echo ""
echo "---"
echo ""

echo "## 🗂️ Package Information"
echo ""
echo "### Installed Packages (Top 20)"
echo '```'
pkg info | head -20
echo '```'
echo ""
echo "---"
echo ""

echo "## 📝 Recent Log Entries"
echo ""
echo "### Firewall Logs (Last 10)"
echo '```'
clog /var/log/filter.log | tail -10
echo '```'
echo ""
echo "### System Logs (Last 10)"
echo '```'
tail -10 /var/log/system.log
echo '```'
echo ""
echo "---"
echo ""

cat << 'FOOTER'
## ℹ️ Export Information

- **Generated**: $(date '+%Y-%m-%d %H:%M:%S')
- **Command**: `generate-opnsense-documentation.sh`
- **Method**: SSH Remote Execution

### How to use this export:

1. **Via SSH Pipe:**
   ```bash
   ssh root@opensence.mrz.ip 'sh' < generate-opnsense-documentation.sh > opnsense-export.md
   ```

2. **Via SCP & SSH:**
   ```bash
   scp generate-opnsense-documentation.sh root@opensence.mrz.ip:/tmp/
   ssh root@opensence.mrz.ip "/tmp/generate-opnsense-documentation.sh" > opnsense-export.md
   ```

3. **Schedule with Cron (on OPNsense):**
   ```bash
   0 2 * * * /path/to/generate-opnsense-documentation.sh > /path/to/opnsense-export.md
   ```

---

[← Back to Main Documentation](HAUPTDOKUMENTATION.md)
FOOTER
