#!/bin/bash

# Proxmox Infrastructure Documentation Script
# Generiert ein Mermaid-Diagramm der gesamten Proxmox-Infrastruktur
# Autor: Julian Wiche
# Datum: 19. November 2025

OUTPUT_FILE="proxmox.md"
TEMP_FILE="/tmp/proxmox_data.json"

# Farben für verschiedene Typen
declare -A COLORS=(
    ["vm"]="fill:#e1f5fe,stroke:#01579b,stroke-width:2px"
    ["lxc"]="fill:#f3e5f5,stroke:#4a148c,stroke-width:2px" 
    ["node"]="fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px"
    ["storage"]="fill:#fff3e0,stroke:#e65100,stroke-width:2px"
    ["cluster"]="fill:#fce4ec,stroke:#880e4f,stroke-width:2px"
    ["network"]="fill:#f1f8e9,stroke:#33691e,stroke-width:2px"
)

echo "🔍 Sammle Proxmox Infrastrukturdaten..."

# Header der Markdown-Datei erstellen
cat > "$OUTPUT_FILE" << 'EOF'
# Proxmox VE Infrastruktur-Dokumentation

Automatisch generiert am: $(date)
Server: $(hostname) ($(hostname -I | awk '{print $1}'))

```mermaid
graph TB
    %% Proxmox Infrastructure Overview
    
    subgraph "Proxmox Cluster"
EOF

# Cluster-Informationen sammeln
echo "    📊 Cluster-Status..."
if command -v pvecm &> /dev/null; then
    CLUSTER_NAME=$(pvecm status 2>/dev/null | grep "Cluster name:" | awk '{print $3}' || echo "standalone")
    echo "        CLUSTER[\"🏢 Cluster: $CLUSTER_NAME\"]" >> "$OUTPUT_FILE"
else
    echo "        CLUSTER[\"🖥️ Standalone Node: $(hostname)\"]" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# Nodes sammeln
echo "    📡 Sammle Node-Informationen..."
echo "    %% Nodes" >> "$OUTPUT_FILE"
if command -v pvesh &> /dev/null; then
    pvesh get /nodes --output-format=json > "$TEMP_FILE" 2>/dev/null || echo "[]" > "$TEMP_FILE"
    
    while IFS= read -r line; do
        if [[ "$line" =~ \"node\":\"([^\"]+)\" ]]; then
            NODE_NAME="${BASH_REMATCH[1]}"
            NODE_STATUS=$(echo "$line" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
            NODE_UPTIME=$(echo "$line" | grep -o '"uptime":"[^"]*"' | cut -d'"' -f4)
            
            echo "        NODE_$NODE_NAME[\"🖥️ $NODE_NAME<br/>Status: $NODE_STATUS<br/>Uptime: ${NODE_UPTIME:-unknown}\"]" >> "$OUTPUT_FILE"
            echo "        CLUSTER --> NODE_$NODE_NAME" >> "$OUTPUT_FILE"
        fi
    done < "$TEMP_FILE"
else
    # Fallback für lokale Node-Info
    NODE_NAME=$(hostname)
    echo "        NODE_$NODE_NAME[\"🖥️ $NODE_NAME<br/>Status: online<br/>Uptime: $(uptime -p)\"]" >> "$OUTPUT_FILE"
    echo "        CLUSTER --> NODE_$NODE_NAME" >> "$OUTPUT_FILE"
fi

echo "" >> "$OUTPUT_FILE"

# VMs sammeln
echo "    🖥️ Sammle VM-Informationen..."
echo "    %% Virtual Machines" >> "$OUTPUT_FILE"

if command -v qm &> /dev/null; then
    qm list | tail -n +2 | while read -r line; do
        if [[ -n "$line" ]]; then
            VMID=$(echo "$line" | awk '{print $1}')
            NAME=$(echo "$line" | awk '{print $2}')
            STATUS=$(echo "$line" | awk '{print $3}')
            MEM=$(echo "$line" | awk '{print $4}')
            BOOTDISK=$(echo "$line" | awk '{print $5}')
            
            # VM-Details abrufen
            if VM_CONFIG=$(qm config "$VMID" 2>/dev/null); then
                CORES=$(echo "$VM_CONFIG" | grep "^cores:" | cut -d' ' -f2)
                MEMORY=$(echo "$VM_CONFIG" | grep "^memory:" | cut -d' ' -f2)
                OS_TYPE=$(echo "$VM_CONFIG" | grep "^ostype:" | cut -d' ' -f2)
                
                echo "        VM_$VMID[\"🖥️ VM $VMID: $NAME<br/>Status: $STATUS<br/>OS: ${OS_TYPE:-unknown}<br/>RAM: ${MEMORY:-$MEM}MB<br/>CPU: ${CORES:-1} Cores<br/>Disk: ${BOOTDISK:-unknown}\"]" >> "$OUTPUT_FILE"
                
                # Verbindung zur Node
                VM_NODE=$(echo "$VM_CONFIG" | grep "^node:" | cut -d' ' -f2 || hostname)
                echo "        NODE_${VM_NODE:-$(hostname)} --> VM_$VMID" >> "$OUTPUT_FILE"
            fi
        fi
    done
fi

echo "" >> "$OUTPUT_FILE"

# LXC Container sammeln
echo "    📦 Sammle LXC-Container..."
echo "    %% LXC Containers" >> "$OUTPUT_FILE"

if command -v pct &> /dev/null; then
    pct list | tail -n +2 | while read -r line; do
        if [[ -n "$line" ]]; then
            CTID=$(echo "$line" | awk '{print $1}')
            STATUS=$(echo "$line" | awk '{print $2}')
            LOCK=$(echo "$line" | awk '{print $3}')
            NAME=$(echo "$line" | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//')
            
            # Container-Details abrufen
            if CT_CONFIG=$(pct config "$CTID" 2>/dev/null); then
                MEMORY=$(echo "$CT_CONFIG" | grep "^memory:" | cut -d' ' -f2)
                CORES=$(echo "$CT_CONFIG" | grep "^cores:" | cut -d' ' -f2)
                OSTYPE=$(echo "$CT_CONFIG" | grep "^ostype:" | cut -d' ' -f2)
                ROOTFS=$(echo "$CT_CONFIG" | grep "^rootfs:" | cut -d' ' -f2)
                
                echo "        LXC_$CTID[\"📦 CT $CTID: $NAME<br/>Status: $STATUS<br/>OS: ${OSTYPE:-linux}<br/>RAM: ${MEMORY:-512}MB<br/>CPU: ${CORES:-1} Cores<br/>Storage: ${ROOTFS:-unknown}\"]" >> "$OUTPUT_FILE"
                
                # Verbindung zur Node
                CT_NODE=$(echo "$CT_CONFIG" | grep "^node:" | cut -d' ' -f2 || hostname)
                echo "        NODE_${CT_NODE:-$(hostname)} --> LXC_$CTID" >> "$OUTPUT_FILE"
            fi
        fi
    done
fi

echo "" >> "$OUTPUT_FILE"

# Storage sammeln
echo "    💾 Sammle Storage-Informationen..."
echo "    %% Storage" >> "$OUTPUT_FILE"

if command -v pvesh &> /dev/null; then
    pvesh get /storage --output-format=json 2>/dev/null | grep -o '"storage":"[^"]*"' | cut -d'"' -f4 | while read -r STORAGE; do
        if [[ -n "$STORAGE" ]]; then
            # Storage-Details abrufen
            STORAGE_INFO=$(pvesh get "/storage/$STORAGE" 2>/dev/null || echo "")
            STORAGE_TYPE=$(echo "$STORAGE_INFO" | grep -o '"type":"[^"]*"' | cut -d'"' -f4)
            STORAGE_CONTENT=$(echo "$STORAGE_INFO" | grep -o '"content":"[^"]*"' | cut -d'"' -f4)
            
            echo "        STORAGE_$STORAGE[\"💾 Storage: $STORAGE<br/>Type: ${STORAGE_TYPE:-unknown}<br/>Content: ${STORAGE_CONTENT:-all}\"]" >> "$OUTPUT_FILE"
            echo "        CLUSTER --> STORAGE_$STORAGE" >> "$OUTPUT_FILE"
        fi
    done
fi

echo "" >> "$OUTPUT_FILE"

# Netzwerk-Informationen sammeln
echo "    🌐 Sammle Netzwerk-Informationen..."
echo "    %% Network Interfaces" >> "$OUTPUT_FILE"

# Netzwerk-Bridges
if command -v ip &> /dev/null; then
    ip link show type bridge | grep -o '^[0-9]*: [^:]*' | cut -d' ' -f2 | while read -r BRIDGE; do
        if [[ -n "$BRIDGE" ]]; then
            BRIDGE_IP=$(ip addr show "$BRIDGE" 2>/dev/null | grep "inet " | awk '{print $2}' | head -1)
            echo "        NET_$BRIDGE[\"🌐 Bridge: $BRIDGE<br/>IP: ${BRIDGE_IP:-no IP}\"]" >> "$OUTPUT_FILE"
            echo "        CLUSTER --> NET_$BRIDGE" >> "$OUTPUT_FILE"
        fi
    done
fi

# Mermaid-Diagramm abschließen
cat >> "$OUTPUT_FILE" << 'EOF'

    end

    %% Styling
    classDef vmClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef lxcClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef nodeClass fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef storageClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef clusterClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef networkClass fill:#f1f8e9,stroke:#33691e,stroke-width:2px

    %% CSS-Klassen zuweisen
EOF

# CSS-Klassen für alle Elemente hinzufügen
echo "    🎨 Füge Styling hinzu..."

# VMs
if command -v qm &> /dev/null; then
    echo "    %% VMs Styling" >> "$OUTPUT_FILE"
    qm list | tail -n +2 | awk '{print $1}' | while read -r VMID; do
        if [[ -n "$VMID" ]]; then
            echo "    class VM_$VMID vmClass" >> "$OUTPUT_FILE"
        fi
    done
fi

# LXC
if command -v pct &> /dev/null; then
    echo "    %% LXC Styling" >> "$OUTPUT_FILE"
    pct list | tail -n +2 | awk '{print $1}' | while read -r CTID; do
        if [[ -n "$CTID" ]]; then
            echo "    class LXC_$CTID lxcClass" >> "$OUTPUT_FILE"
        fi
    done
fi

# Nodes
echo "    %% Nodes Styling" >> "$OUTPUT_FILE"
if command -v pvesh &> /dev/null; then
    pvesh get /nodes --output-format=json 2>/dev/null | grep -o '"node":"[^"]*"' | cut -d'"' -f4 | while read -r NODE; do
        if [[ -n "$NODE" ]]; then
            echo "    class NODE_$NODE nodeClass" >> "$OUTPUT_FILE"
        fi
    done
else
    echo "    class NODE_$(hostname) nodeClass" >> "$OUTPUT_FILE"
fi

# Storage
if command -v pvesh &> /dev/null; then
    echo "    %% Storage Styling" >> "$OUTPUT_FILE"
    pvesh get /storage --output-format=json 2>/dev/null | grep -o '"storage":"[^"]*"' | cut -d'"' -f4 | while read -r STORAGE; do
        if [[ -n "$STORAGE" ]]; then
            echo "    class STORAGE_$STORAGE storageClass" >> "$OUTPUT_FILE"
        fi
    done
fi

# Network
echo "    %% Network Styling" >> "$OUTPUT_FILE"
ip link show type bridge 2>/dev/null | grep -o '^[0-9]*: [^:]*' | cut -d' ' -f2 | while read -r BRIDGE; do
    if [[ -n "$BRIDGE" ]]; then
        echo "    class NET_$BRIDGE networkClass" >> "$OUTPUT_FILE"
    fi
done

# Cluster
echo "    class CLUSTER clusterClass" >> "$OUTPUT_FILE"

# Mermaid-Block schließen
echo '```' >> "$OUTPUT_FILE"

# Zusätzliche Informationen hinzufügen
cat >> "$OUTPUT_FILE" << 'EOF'

## 📊 Detaillierte Informationen

### 🖥️ System-Informationen
EOF

echo "- **Hostname**: $(hostname)" >> "$OUTPUT_FILE"
echo "- **IP-Adresse**: $(hostname -I | awk '{print $1}')" >> "$OUTPUT_FILE"
echo "- **Uptime**: $(uptime -p)" >> "$OUTPUT_FILE"
echo "- **Kernel**: $(uname -r)" >> "$OUTPUT_FILE"
echo "- **Proxmox Version**: $(pveversion | head -1)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# VM-Tabelle
cat >> "$OUTPUT_FILE" << 'EOF'
### 🖥️ Virtual Machines

| VMID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
EOF

if command -v qm &> /dev/null; then
    qm list | tail -n +2 | while read -r line; do
        if [[ -n "$line" ]]; then
            VMID=$(echo "$line" | awk '{print $1}')
            NAME=$(echo "$line" | awk '{print $2}')
            STATUS=$(echo "$line" | awk '{print $3}')
            
            if VM_CONFIG=$(qm config "$VMID" 2>/dev/null); then
                MEMORY=$(echo "$VM_CONFIG" | grep "^memory:" | cut -d' ' -f2)
                CORES=$(echo "$VM_CONFIG" | grep "^cores:" | cut -d' ' -f2)
                OS_TYPE=$(echo "$VM_CONFIG" | grep "^ostype:" | cut -d' ' -f2)
                BOOTDISK=$(echo "$VM_CONFIG" | grep "bootdisk:" | cut -d' ' -f2)
                
                echo "| $VMID | $NAME | $STATUS | ${MEMORY:-512}MB | ${CORES:-1} | ${BOOTDISK:-unknown} | ${OS_TYPE:-unknown} |" >> "$OUTPUT_FILE"
            fi
        fi
    done
fi

# LXC-Tabelle
cat >> "$OUTPUT_FILE" << 'EOF'

### 📦 LXC Containers

| CTID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
EOF

if command -v pct &> /dev/null; then
    pct list | tail -n +2 | while read -r line; do
        if [[ -n "$line" ]]; then
            CTID=$(echo "$line" | awk '{print $1}')
            STATUS=$(echo "$line" | awk '{print $2}')
            NAME=$(echo "$line" | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//')
            
            if CT_CONFIG=$(pct config "$CTID" 2>/dev/null); then
                MEMORY=$(echo "$CT_CONFIG" | grep "^memory:" | cut -d' ' -f2)
                CORES=$(echo "$CT_CONFIG" | grep "^cores:" | cut -d' ' -f2)
                OSTYPE=$(echo "$CT_CONFIG" | grep "^ostype:" | cut -d' ' -f2)
                ROOTFS=$(echo "$CT_CONFIG" | grep "^rootfs:" | cut -d' ' -f2 | cut -d',' -f1)
                
                echo "| $CTID | $NAME | $STATUS | ${MEMORY:-512}MB | ${CORES:-1} | ${ROOTFS:-unknown} | ${OSTYPE:-linux} |" >> "$OUTPUT_FILE"
            fi
        fi
    done
fi

# Storage-Tabelle
cat >> "$OUTPUT_FILE" << 'EOF'

### 💾 Storage

| Name | Type | Content | Status |
|------|------|---------|--------|
EOF

if command -v pvesh &> /dev/null; then
    pvesh get /storage --output-format=json 2>/dev/null | jq -r '.[] | "\(.storage) \(.type) \(.content // "all") \(.enabled // "unknown")"' 2>/dev/null | while read -r STORAGE TYPE CONTENT ENABLED; do
        echo "| $STORAGE | $TYPE | $CONTENT | $ENABLED |" >> "$OUTPUT_FILE"
    done 2>/dev/null || {
        # Fallback ohne jq
        pvesh get /storage --output-format=json 2>/dev/null | grep -o '"storage":"[^"]*"' | cut -d'"' -f4 | while read -r STORAGE; do
            echo "| $STORAGE | unknown | unknown | unknown |" >> "$OUTPUT_FILE"
        done
    }
fi

# Abschluss
cat >> "$OUTPUT_FILE" << 'EOF'

---
*Automatisch generiert durch Proxmox Documentation Script*  
*Datum: $(date)*  
*Server: $(hostname)*
EOF

# Aufräumen
rm -f "$TEMP_FILE"

echo "✅ Dokumentation erfolgreich erstellt: $OUTPUT_FILE"
echo "📊 Zusammenfassung:"
echo "   - VMs: $(qm list 2>/dev/null | wc -l | awk '{print $1-1}' 2>/dev/null || echo "0")"
echo "   - LXC: $(pct list 2>/dev/null | wc -l | awk '{print $1-1}' 2>/dev/null || echo "0")"
echo "   - Storage: $(pvesh get /storage 2>/dev/null | grep -c '"storage":' || echo "0")"
echo ""
echo "💡 Zum Anzeigen des Diagramms:"
echo "   - Datei in VS Code mit Mermaid-Extension öffnen"
echo "   - Oder online unter: https://mermaid.live/"
echo ""
echo "🔄 Script erneut ausführen für Updates:"
echo "   bash $(basename "$0")"