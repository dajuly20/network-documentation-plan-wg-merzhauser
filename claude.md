# Claude.md – Projektkontext für `karola-gerhard-chatgpt`

## 🧠 Projektziel

Dokumentation der Heimnetz- und Multi-Site-Infrastruktur von Julian Wiche mit Fokus auf:
- Switch-Port-Zuordnung (beginnend mit `mrz.ip`)
- VLAN-Management
- DNS- und VPN-Topologie
- Verteilte Dienste über Standorte und externen vServer (`julianw.de`, `wiche.eu`, `lisamae.de`)
- Zentrale Verwaltung über GitHub mit Mermaid + Markdown

---

## 🔧 Technischer Stack

- **Netzwerk-Hardware**: Zyxel XGS1210-12 (SFP, VLAN)
- **DNS**: Pi-hole auf `pihole.mrz.ip` / `wg.weis.er` (192.168.188.2)
- **Router**: FritzBox (`box.mrz.ip`, 192.168.188.1), vermutlich DHCP + NAT
- **Mermaid**: als Diagrammformat in `.md`-Dateien (VS Code Plugin aktiv)
- **GitHub CLI**: Repository-Verwaltung mit `gh repo create`

---

## 📂 Repo-Struktur (Stand: v2)

- `README.md` – Projektübersicht
- `switch-mrz.md` – Mermaid-Diagramm des Switches im `mrz.ip`-Netz
- `LICENSE` – MIT-Lizenz (Standard)
- `.gitignore` – für lokale IDE- und Systemdateien
- `claude.md` – dieser Kontext

---

## 📍 Netzwerkstandort: `mrz.ip`

### 🔌 Subnetz
- `192.168.188.0/24`

### 🌐 Router
- `192.168.188.1` (`box.mrz.ip`)
- FritzBox, Gateway + DHCP

### 🧠 DNS
- Pi-hole: `192.168.188.2` (`pihole.mrz.ip` / `wg.weis.er`)
- interne `.ip`-Zonen (z. B. `*.mrz.ip`, `*.julianw.ip`)

### 🌐 VPN
- Site-to-site VPN vorhanden (Details folgen)
- vServer als zentrales Routing-Gateway für Domains

---

## 🔀 Nächste Diagramm-Ideen

- `dns-flow.md`: DNS-Flüsse lokal → Pi-hole → ggf. Forwarder
- `vpn-map.md`: VPN-Matrix zwischen Sites + vServer
- `vserver.md`: Architektur externer Dienste, Domains, Proxy-Logik
- `julian-overview.md`: globaler Netzplan aller Standorte

---

