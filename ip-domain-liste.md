# IP-Adressen und Domains Liste (Vollständig)

## 📡 IP-Adressen

### Netzwerk-Infrastructure

| IP-Adresse | Hostname | Beschreibung | VLAN/Typ |
|------------|----------|--------------|----------|
| `192.168.188.1` | `box.mrz.ip` | FritzBox 5590 Fiber Router/Gateway | VLAN 4 |
| `192.168.188.2` | `pihole.mrz.ip` / `ganzNeuerPiHole` / `wg.weis.er` | Pi-hole DNS Server | VLAN 1 |
| `192.168.188.254` | `openSence.mrz.ip` | OPNsense Firewall (alle VLANs) | Gateway |
| `10.0.0.254` | - | IoT VLAN Gateway | IoT VLAN |

### Subnetz

| Subnetz | Beschreibung |
|---------|--------------|
| `192.168.188.0/24` | Hauptnetzwerk mrz.ip |
| `10.0.0.0/24` | IoT VLAN |

### LAN-Geräte (über Switch)

| IP-Adresse | Hostname | Beschreibung |
|------------|----------|--------------|
| `192.168.188.3` | proxmox-turbo-2-5-gbit | Proxmox Turbo Server |
| `192.168.188.34` | AlexaJulian / linux | Amazon Echo / Linux System |
| `192.168.188.54` | core-switch | Core Switch |
| `192.168.188.57` | helper-switch | Helper Switch |
| `192.168.188.58` | 192-168-188-58 | Unbekanntes Gerät |
| `192.168.188.61` | Unify-U6-Pro | UniFi Access Point |
| `192.168.188.79` | ap.mrz.ip | FRITZ!Box 7490 (Access Point) |
| `192.168.188.92` | pbx.mrz.ip | PBX System |
| `192.168.188.102` | amazon-firetv-wohnzimmer | FireTV Wohnzimmer |
| `192.168.188.120` | JohannesBalkonkraftwerk | Balkonkraftwerk |
| `192.168.188.149` | amazon-firetv-julian | FireTV Julian |
| `192.168.188.153` | mint | Linux Mint |
| `192.168.188.156` | pve-backup.mrz.ip | Proxmox Backup |
| `192.168.188.173` | onkyo-mrz-ip | Onkyo Receiver |
| `192.168.188.177` | pve | Proxmox VE (Web: https://192.168.188.177:8006/) |
| `192.168.188.178` | homeassistant-VM | Home Assistant VM |
| `192.168.188.179` | proxmox-docker | Proxmox Docker |

### WLAN-Geräte (Auswahl wichtiger)

| IP-Adresse | Hostname | Beschreibung |
|------------|----------|--------------|
| `192.168.188.4` | edge.mrz.ip | Edge Device |
| `192.168.188.20` | shellyuni | Shelly Uni |
| `192.168.188.24` | shelly1-monitor | Shelly Monitor |
| `192.168.188.73` | JulianPhillipsTV | Philips TV |
| `192.168.188.88` | shellyuni-98CDAC2B78CF | Shelly Uni |
| `192.168.188.96` | volumio | Volumio |
| `192.168.188.97` | shelly-spiegelleuchte | Shelly Spiegelleuchte |
| `192.168.188.113` | geschirrspuehler-siemens | Geschirrspüler (WLAN 5GHz) |
| `192.168.188.123` | shelly1-universum | Shelly Universum |
| `192.168.188.141` | julian-Precision-5550 | Julian's Laptop |
| `192.168.188.151` | bett.mrz.ip | Gerät am Bett |
| `192.168.188.155` | shellyix3-JULIAN-LICHTSCHALTER | Shelly Lichtschalter |
| `192.168.188.157` | schreibtisch.mrz.ip | Schreibtisch Gerät |
| `192.168.188.162` | sony-receiver | Sony Receiver |
| `192.168.188.196` | win.mrz.ip | Windows System |

### VPN-Verbindungen

#### Wireguard VPN (192.168.188.205-219)

| VPN-IP | Client-Name | Beschreibung |
|--------|-------------|--------------|
| `192.168.188.205` | JulSrv1000 | Server 1000 |
| `192.168.188.207` | JulSrvNew | Neuer Server |
| `192.168.188.208` | ArbeitslaptopLinux | Work Laptop Linux |
| `192.168.188.209` | Arbeitslaptop | Work Laptop |
| `192.168.188.210` | JuliansHandy | Julian's Phone |
| `192.168.188.211` | RomisExKrikoLaptop | Romi's Laptop |
| `192.168.188.212` | JulianW.de-TestfutureClone | Test Clone |
| `192.168.188.213` | JulianwDeTestClone2 | Test Clone 2 |
| `192.168.188.214` | new.julianw.de | New Server |
| `192.168.188.215` | juli-ueberall | Julian Mobile |
| `192.168.188.216` | neuerDellPrecsicion2025 | Dell Precision 2025 |
| `192.168.188.217` | ArbeitsLaptopNeu | New Work Laptop |
| `192.168.188.218` | ttt | Test |
| `192.168.188.219` | NeuerDellPrecsicion5550 | Dell Precision 5550 |

#### IPSec VPN (192.168.188.201-206)

| VPN-IP | Client-Name | Beschreibung |
|--------|-------------|--------------|
| `192.168.188.201` | JulSrv | Server |
| `192.168.188.202` | Johannes Fries | Johannes |
| `192.168.188.203` | julian | Julian |
| `192.168.188.204` | Box2Go | Mobile Box |
| `192.168.188.206` | Lisasupertramp.de | Lisa's Server |

## 🌐 Domains

### Externe Domains (vServer)

| Domain | Beschreibung |
|--------|--------------|
| `julianw.de` | Externe Domain (vServer) |
| `wiche.eu` | Externe Domain (vServer) |
| `lisamae.de` | Externe Domain (vServer) |

### Interne Domains/Zonen

| Domain/Zone | Beschreibung |
|-------------|--------------|
| `mrz.ip` | Hauptzone für lokales Netzwerk |
| `wg.weis.er` | Alternative Domain für Pi-hole (192.168.188.2) |
| `julianw.ip` | Weitere interne Zone |
| `*.mrz.ip` | Alle Subdomains der mrz.ip Zone |
| `*.julianw.ip` | Alle Subdomains der julianw.ip Zone |

## 🖥️ Gerätezuordnungen (Switch Ports)

| Port | Gerät | IP/Hostname | VLAN | Status |
|------|-------|-------------|------|--------|
| 1 | FritzBox | `192.168.188.1` / `box.mrz.ip` | VLAN 4 | ✅ Aktiv |
| 2 | Schrank-Switch | - | VLAN 1+4 | ✅ Aktiv |
| 3 | Zigbee Pi | - | VLAN 1 | ✅ Aktiv |
| 4 | Onkyo Receiver | - | VLAN 1 | ✅ Aktiv |
| 5 | RetroPie | - | VLAN 1 | ✅ Aktiv |
| 6 | Gerät frei | - | - | ❌ Frei |
| 7 | Gerät frei | - | - | ❌ Frei |
| 8 | Gerät frei | - | - | ❌ Frei |
| 9 | FireTV | - | VLAN 1 | ✅ Aktiv |
| 10 | Pi-hole | `192.168.188.2` / `pihole.mrz.ip` | VLAN 1 | ✅ Aktiv |
| 11 | PC „jul" | - | VLAN 1 | ✅ Aktiv |
| 12 | Gerät unbekannt | - | - | ❓ Unbekannt |

## 🌐 Wichtige Web-Interfaces

| Service | URL | IP-Adresse | Beschreibung |
|---------|-----|------------|--------------|
| Pi-hole DNS | <http://wg.weis.er/> | 192.168.188.2 | DNS Server Management |
| Proxmox VE | <https://192.168.188.177:8006/> | 192.168.188.177 | Virtualisierung Management |
| OPNsense Firewall | <http://openSence.mrz.ip/> | 192.168.188.254 | Firewall Management (alle VLANs) |
| IoT VLAN Gateway | <http://10.0.0.254/> | 10.0.0.254 | IoT VLAN Management |

## 📋 Zusammenfassung

**Insgesamt gefunden aus FritzBox 5590 Fiber:**

- ✅ **~90 IP-Adressen** (192.168.188.1-254 + 10.0.0.254)
- ✅ **25 VPN-Verbindungen** (15x Wireguard + 5x IPSec)
- ✅ **~60 LAN/WLAN-Geräte** (Server, PCs, Smart Home, etc.)
- ✅ **3 externe Domains** (julianw.de, wiche.eu, lisamae.de)
- ✅ **4 interne Zones/Domains** (mrz.ip, julianw.ip, \*.mrz.ip, \*.julianw.ip)
- ✅ **2 Subnetze** (192.168.188.0/24 + 10.0.0.0/24 IoT VLAN)

### 🔧 Wichtige Infrastructure-IPs:
- **Router**: 192.168.188.1 (FritzBox 5590 Fiber)
- **DNS**: 192.168.188.2 (Pi-hole)
- **Firewall**: 192.168.188.254 (OPNsense)
- **IoT Gateway**: 10.0.0.254

---
*Erstellt am: 19. November 2025*  
*Quelle: Network Documentation Plan WG Merzhauser + FritzBox Geräteliste*