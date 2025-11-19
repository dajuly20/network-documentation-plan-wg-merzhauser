# KI-Kontext-Dokumentation (`claude/`)

Dieser Ordner enthält alle Dokumente, die KI-Assistenten (ChatGPT, Claude etc.) benötigen, um im Projekt konsistent, strukturiert und kontextbewusst zu arbeiten.

## Inhalte

- `claude.md` – Zentrales Kontextdokument (Netzwerk, Proxmox, VLANs, Dienste, Architektur).
- `diagrams/` – Alle Mermaid-Diagramme einzeln als `.mmd` zum einfachen Rendern.
- `tables/` – Tabellarische Übersichten (Netze, Hosts, Dienste usw.).
- `Makefile` – Macht aus `.mmd`-Dateien automatisch gerenderte PNG/SVG-Diagramme.

## Diagramme generieren

Voraussetzung: Mermaid CLI (`mmdc`)

Installation:
```bash
npm install -g @mermaid-js/mermaid-cli
```

Alle Diagramme generieren:
```bash
make diagrams
```

Nur ein Diagramm erzeugen (Beispiel):
```bash
make diagrams/sites.png
```

Alle Dateien werden im Unterordner `diagrams/` erzeugt:

```
diagrams/
├── sites.mmd        → sites.png / sites.svg
├── vlans.mmd        → vlans.png / vlans.svg
├── backup-flow.mmd  → backup-flow.png / backup-flow.svg
├── docker-topology.mmd → docker-topology.png / docker-topology.svg
├── vpn-topology.mmd    → vpn-topology.png / vpn-topology.svg
└── ha-flow.mmd         → ha-flow.png / ha-flow.svg
```
