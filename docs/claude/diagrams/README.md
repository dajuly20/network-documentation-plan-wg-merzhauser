# Mermaid-Diagramme

In diesem Ordner liegen alle Architektur- und Netzwerkdiagramme als Mermaid-Quelltext (`.mmd`).

Die Diagramme werden nicht manuell gerendert eingecheckt, sondern bei Bedarf mit dem `Makefile` im übergeordneten Ordner erzeugt.

Beispiele:
```bash
# Alle Diagramme rendern
make diagrams

# Nur ein bestimmtes Diagramm rendern (PNG & SVG)
make diagrams/sites.png
make diagrams/sites.svg
```
