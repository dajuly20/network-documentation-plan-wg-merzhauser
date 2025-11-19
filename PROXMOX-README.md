# Proxmox Documentation Script

## 📋 Übersicht

Dieses Script automatisiert die Dokumentation Ihrer gesamten Proxmox VE Infrastruktur und generiert ein umfassendes Mermaid-Diagramm mit allen VMs, LXC-Containern, Storage-Systemen und Netzwerk-Konfigurationen.

## 🚀 Installation & Verwendung

### 1. Script auf Proxmox Server kopieren

```bash
# Script ausführbar machen
chmod +x generate-proxmox-documentation.sh

# Script ausführen
./generate-proxmox-documentation.sh
```

### 2. Alternative: Direkte Ausführung

```bash
# Script herunterladen und direkt ausführen
curl -sSL https://raw.githubusercontent.com/your-repo/proxmox-docs/main/generate-proxmox-documentation.sh | bash
```

## 📊 Generierte Ausgabe

Das Script erstellt eine `proxmox.md` Datei mit:

### 🎨 Mermaid-Diagramm
- **Cluster-Übersicht** mit allen Nodes
- **VMs** mit Status, RAM, CPU und Storage
- **LXC Container** mit Konfigurationsdetails
- **Storage-Systeme** und deren Typen
- **Netzwerk-Bridges** und IP-Konfigurationen
- **Farbcodierte Visualisierung** nach Typ

### 📋 Detaillierte Tabellen
- **System-Informationen** (Hostname, IP, Uptime, Proxmox Version)
- **VM-Tabelle** mit allen technischen Details
- **LXC-Tabelle** mit Container-Konfigurationen
- **Storage-Übersicht** mit Typen und Inhalten

## 🔧 Voraussetzungen

- **Proxmox VE** Server mit CLI-Tools
- **Bash** Shell (Standard auf Proxmox)
- **Root-Rechte** oder Proxmox-Benutzer mit ausreichenden Berechtigungen

## 📁 Ausgabe-Dateien

| Datei | Beschreibung |
|-------|--------------|
| `proxmox.md` | Hauptdokumentation mit Mermaid-Diagramm |
| `/tmp/proxmox_data.json` | Temporäre Daten (wird automatisch gelöscht) |

## 🎯 Verwendungszwecke

- **Infrastruktur-Dokumentation** für Teams
- **Disaster Recovery** Planung
- **Kapazitäts-Planung** und Resource-Management
- **Compliance** und Audit-Vorbereitung
- **Onboarding** neuer Teammitglieder

## 🔄 Automatisierung

### Cron-Job für regelmäßige Updates

```bash
# Dokumentation täglich um 2 Uhr aktualisieren
0 2 * * * /path/to/generate-proxmox-documentation.sh

# Dokumentation stündlich aktualisieren
0 * * * * /path/to/generate-proxmox-documentation.sh
```

### Integration in CI/CD Pipeline

```yaml
# Beispiel für GitLab CI
proxmox-docs:
  stage: documentation
  script:
    - scp generate-proxmox-documentation.sh root@proxmox-server:/tmp/
    - ssh root@proxmox-server "chmod +x /tmp/generate-proxmox-documentation.sh"
    - ssh root@proxmox-server "/tmp/generate-proxmox-documentation.sh"
    - scp root@proxmox-server:/tmp/proxmox.md ./
  artifacts:
    paths:
      - proxmox.md
```

## 🎨 Mermaid-Diagramm anzeigen

### VS Code
1. Mermaid Preview Extension installieren
2. `proxmox.md` öffnen
3. `Ctrl+Shift+P` → "Mermaid: Preview"

### Online
1. Dateiinhalt kopieren
2. Auf [mermaid.live](https://mermaid.live/) einfügen
3. Diagramm wird automatisch gerendert

### GitHub/GitLab
Mermaid-Diagramme werden automatisch in README-Dateien gerendert.

## 🔍 Troubleshooting

### Fehlende Berechtigungen
```bash
# Script mit sudo ausführen
sudo ./generate-proxmox-documentation.sh
```

### Proxmox Tools nicht gefunden
```bash
# Prüfen ob Proxmox CLI-Tools verfügbar sind
which pvesh qm pct pvecm
```

### JSON-Parser Fehler
Das Script funktioniert auch ohne `jq`, verwendet dann Fallback-Methoden.

## 📈 Ausgabe-Beispiel

```
✅ Dokumentation erfolgreich erstellt: proxmox.md
📊 Zusammenfassung:
   - VMs: 12
   - LXC: 8
   - Storage: 4

💡 Zum Anzeigen des Diagramms:
   - Datei in VS Code mit Mermaid-Extension öffnen
   - Oder online unter: https://mermaid.live/
```

## 🤝 Beitragen

Verbesserungen und Feature-Requests sind willkommen!

1. Fork das Repository
2. Feature-Branch erstellen (`git checkout -b feature/amazing-feature`)
3. Änderungen committen (`git commit -m 'Add amazing feature'`)
4. Branch pushen (`git push origin feature/amazing-feature`)
5. Pull Request erstellen

## 📄 Lizenz

MIT License - siehe `LICENSE` Datei für Details.

---
*Script erstellt für Proxmox VE Infrastructure Documentation*