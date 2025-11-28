#!/bin/sh
################################################################################
# Internet Connectivity Test Script für OPNsense
#
# Testet die Internet-Konnektivität durch verschiedene Prüfungen
#
# Verwendung:
#   ssh root@opensence.mrz.ip 'sh' < test-internet-connectivity.sh
#   oder
#   scp test-internet-connectivity.sh root@opensence.mrz.ip:/tmp/
#   ssh root@opensence.mrz.ip "sh /tmp/test-internet-connectivity.sh"
################################################################################

echo "================================"
echo "🔍 Internet-Konnektivitäts-Test"
echo "================================"
echo ""
echo "Host: $(hostname)"
echo "Zeit: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "================================"
echo ""

# Test 1: Gateway (FritzBox)
echo "1️⃣  Gateway-Test (FritzBox 192.168.188.1):"
echo "   └─ Ping..."
if ping -c 2 -W 2 192.168.188.1 > /dev/null 2>&1; then
    echo "   ✅ Gateway erreichbar"
else
    echo "   ❌ Gateway NICHT erreichbar - KRITISCH!"
fi
echo ""

# Test 2: OPNsense LAN Interface
echo "2️⃣  OPNsense LAN Interface (192.168.188.254):"
echo "   └─ Loopback-Test..."
if ping -c 2 -W 2 192.168.188.254 > /dev/null 2>&1; then
    echo "   ✅ LAN Interface OK"
else
    echo "   ❌ LAN Interface Problem"
fi
echo ""

# Test 3: Internet Connectivity (Google DNS)
echo "3️⃣  Internet-Konnektivität (8.8.8.8 - Google DNS):"
echo "   └─ Ping..."
if ping -c 3 -W 3 8.8.8.8 > /dev/null 2>&1; then
    echo "   ✅ Internet erreichbar"
    INTERNET_OK=1
else
    echo "   ❌ Internet NICHT erreichbar"
    INTERNET_OK=0
fi
echo ""

# Test 4: Alternative DNS (Cloudflare)
echo "4️⃣  Alternative DNS-Test (1.1.1.1 - Cloudflare):"
echo "   └─ Ping..."
if ping -c 2 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "   ✅ Cloudflare DNS erreichbar"
else
    echo "   ❌ Cloudflare DNS nicht erreichbar"
fi
echo ""

# Test 5: DNS Resolution
echo "5️⃣  DNS-Auflösung (google.com):"
echo "   └─ Ping mit Hostnamen..."
if ping -c 2 -W 3 google.com > /dev/null 2>&1; then
    echo "   ✅ DNS funktioniert"
    DNS_OK=1
else
    echo "   ❌ DNS funktioniert NICHT"
    DNS_OK=0
fi
echo ""

# Test 6: Routing
echo "6️⃣  Routing-Konfiguration:"
echo "   └─ Default Gateway:"
DEFAULT_GW=$(netstat -rn | grep "^default" | awk '{print $2}' | head -1)
if [ -n "$DEFAULT_GW" ]; then
    echo "   ✅ Default Gateway: $DEFAULT_GW"
else
    echo "   ❌ Kein Default Gateway gefunden!"
fi
echo ""

# Test 7: Interface Status
echo "7️⃣  Network Interface Status:"
echo "   └─ Aktive Interfaces:"
ifconfig | grep "^[a-z]" | grep -v "^lo" | while read iface rest; do
    iface_name=$(echo $iface | sed 's/://')
    status=$(ifconfig $iface_name | grep "status:" | awk '{print $2}')
    if [ "$status" = "active" ]; then
        echo "   ✅ $iface_name: $status"
    else
        echo "   ⚠️  $iface_name: $status"
    fi
done
echo ""

# Test 8: DNS Server Configuration
echo "8️⃣  DNS Server Konfiguration:"
echo "   └─ Konfigurierte DNS Server:"
grep "^nameserver" /etc/resolv.conf | while read ns ip; do
    echo "   📍 $ip"
done
echo ""

# Zusammenfassung
echo "================================"
echo "📊 ZUSAMMENFASSUNG"
echo "================================"
echo ""

ERRORS=0

if [ "$INTERNET_OK" = "1" ]; then
    echo "✅ Internet-Konnektivität: OK"
else
    echo "❌ Internet-Konnektivität: FEHLER"
    ERRORS=$((ERRORS + 1))
fi

if [ "$DNS_OK" = "1" ]; then
    echo "✅ DNS-Auflösung: OK"
else
    echo "❌ DNS-Auflösung: FEHLER"
    ERRORS=$((ERRORS + 1))
fi

if [ -n "$DEFAULT_GW" ]; then
    echo "✅ Routing: OK (Gateway: $DEFAULT_GW)"
else
    echo "❌ Routing: FEHLER (Kein Gateway)"
    ERRORS=$((ERRORS + 1))
fi

echo ""

if [ $ERRORS -eq 0 ]; then
    echo "🎉 Alle Tests erfolgreich! Internet-Zugriff funktioniert."
    exit 0
else
    echo "⚠️  $ERRORS Fehler gefunden. Bitte Konfiguration prüfen!"
    echo ""
    echo "💡 Troubleshooting-Tipps:"
    echo "   1. Firewall-Regeln prüfen: Firewall → Rules → LAN"
    echo "   2. NAT-Konfiguration prüfen: Firewall → NAT → Outbound"
    echo "   3. Gateway-Einstellungen: System → Gateways → Single"
    echo "   4. DNS-Einstellungen: System → Settings → General"
    echo "   5. Logs prüfen: Firewall → Log Files → Live View"
    exit 1
fi
