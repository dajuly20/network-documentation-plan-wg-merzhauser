#!/bin/bash

# Proxmox Documentation Script - Test Version
# Generiert Beispiel-Daten für Demo-Zwecke
# Für Testzwecke ohne echte Proxmox-Umgebung

OUTPUT_FILE="proxmox-demo.md"

echo "🧪 Erstelle Demo-Dokumentation der Proxmox-Infrastruktur..."

cat > "$OUTPUT_FILE" << EOF
# Proxmox VE Infrastruktur-Dokumentation (Demo)

Automatisch generiert am: $(date)
Server: pve.mrz.ip (192.168.188.177)

\`\`\`mermaid
graph TB
    %% Proxmox Infrastructure Overview
    
    subgraph "Proxmox Cluster: homelab"
        
        %% Cluster
        CLUSTER["🏢 Cluster: homelab"]
        
        %% Nodes
        NODE_pve["🖥️ pve<br/>Status: online<br/>Uptime: 15 days"]
        NODE_pve2["🖥️ pve-backup<br/>Status: online<br/>Uptime: 12 days"]
        
        CLUSTER --> NODE_pve
        CLUSTER --> NODE_pve2
        
        %% Virtual Machines
        VM_100["🖥️ VM 100: ubuntu-server<br/>Status: running<br/>OS: ubuntu<br/>RAM: 4096MB<br/>CPU: 4 Cores<br/>Disk: local-lvm:vm-100"]
        VM_101["🖥️ VM 101: windows-10<br/>Status: stopped<br/>OS: win10<br/>RAM: 8192MB<br/>CPU: 6 Cores<br/>Disk: local-lvm:vm-101"]
        VM_102["🖥️ VM 102: opnsense<br/>Status: running<br/>OS: other<br/>RAM: 2048MB<br/>CPU: 2 Cores<br/>Disk: local-lvm:vm-102"]
        
        NODE_pve --> VM_100
        NODE_pve --> VM_101
        NODE_pve2 --> VM_102
        
        %% LXC Containers
        LXC_200["📦 CT 200: docker-host<br/>Status: running<br/>OS: ubuntu<br/>RAM: 2048MB<br/>CPU: 2 Cores<br/>Storage: local-lvm:vm-200-disk-0"]
        LXC_201["📦 CT 201: web-server<br/>Status: running<br/>OS: debian<br/>RAM: 1024MB<br/>CPU: 2 Cores<br/>Storage: local-lvm:vm-201-disk-0"]
        LXC_202["📦 CT 202: home-assistant<br/>Status: running<br/>OS: debian<br/>RAM: 1024MB<br/>CPU: 1 Cores<br/>Storage: local-lvm:vm-202-disk-0"]
        LXC_203["📦 CT 203: pihole-backup<br/>Status: stopped<br/>OS: debian<br/>RAM: 512MB<br/>CPU: 1 Cores<br/>Storage: local-lvm:vm-203-disk-0"]
        
        NODE_pve --> LXC_200
        NODE_pve --> LXC_201
        NODE_pve2 --> LXC_202
        NODE_pve2 --> LXC_203
        
        %% Storage
        STORAGE_local["💾 Storage: local<br/>Type: dir<br/>Content: iso,backup"]
        STORAGE_local_lvm["💾 Storage: local-lvm<br/>Type: lvmthin<br/>Content: images,rootdir"]
        STORAGE_backup["💾 Storage: backup-nfs<br/>Type: nfs<br/>Content: backup"]
        STORAGE_iso["💾 Storage: iso-storage<br/>Type: nfs<br/>Content: iso,vztmpl"]
        
        CLUSTER --> STORAGE_local
        CLUSTER --> STORAGE_local_lvm
        CLUSTER --> STORAGE_backup
        CLUSTER --> STORAGE_iso
        
        %% Network
        NET_vmbr0["🌐 Bridge: vmbr0<br/>IP: 192.168.188.177/24"]
        NET_vmbr1["🌐 Bridge: vmbr1<br/>IP: 10.0.0.1/24"]
        NET_vmbr2["🌐 Bridge: vmbr2<br/>IP: no IP"]
        
        CLUSTER --> NET_vmbr0
        CLUSTER --> NET_vmbr1
        CLUSTER --> NET_vmbr2
        
    end

    %% Styling
    classDef vmClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef lxcClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef nodeClass fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef storageClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef clusterClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef networkClass fill:#f1f8e9,stroke:#33691e,stroke-width:2px

    %% VMs Styling
    class VM_100 vmClass
    class VM_101 vmClass
    class VM_102 vmClass
    
    %% LXC Styling
    class LXC_200 lxcClass
    class LXC_201 lxcClass
    class LXC_202 lxcClass
    class LXC_203 lxcClass
    
    %% Nodes Styling
    class NODE_pve nodeClass
    class NODE_pve2 nodeClass
    
    %% Storage Styling
    class STORAGE_local storageClass
    class STORAGE_local_lvm storageClass
    class STORAGE_backup storageClass
    class STORAGE_iso storageClass
    
    %% Network Styling
    class NET_vmbr0 networkClass
    class NET_vmbr1 networkClass
    class NET_vmbr2 networkClass
    
    %% Cluster
    class CLUSTER clusterClass
\`\`\`

## 📊 Detaillierte Informationen

### 🖥️ System-Informationen
- **Hostname**: pve.mrz.ip
- **IP-Adresse**: 192.168.188.177
- **Uptime**: 15 days, 4 hours, 32 minutes
- **Kernel**: 6.8.12-1-pve
- **Proxmox Version**: pve-manager/8.1.4/ec5affc9e2e6c001

### 🖥️ Virtual Machines

| VMID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
| 100 | ubuntu-server | running | 4096MB | 4 | local-lvm:vm-100-disk-0 | ubuntu |
| 101 | windows-10 | stopped | 8192MB | 6 | local-lvm:vm-101-disk-0 | win10 |
| 102 | opnsense | running | 2048MB | 2 | local-lvm:vm-102-disk-0 | other |

### 📦 LXC Containers

| CTID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
| 200 | docker-host | running | 2048MB | 2 | local-lvm:vm-200-disk-0 | ubuntu |
| 201 | web-server | running | 1024MB | 2 | local-lvm:vm-201-disk-0 | debian |
| 202 | home-assistant | running | 1024MB | 1 | local-lvm:vm-202-disk-0 | debian |
| 203 | pihole-backup | stopped | 512MB | 1 | local-lvm:vm-203-disk-0 | debian |

### 💾 Storage

| Name | Type | Content | Status |
|------|------|---------|--------|
| local | dir | iso,backup | enabled |
| local-lvm | lvmthin | images,rootdir | enabled |
| backup-nfs | nfs | backup | enabled |
| iso-storage | nfs | iso,vztmpl | enabled |

### 🌐 Network Bridges

| Bridge | IP-Adresse | Beschreibung |
|--------|-----------|--------------|
| vmbr0 | 192.168.188.177/24 | Main Network Bridge |
| vmbr1 | 10.0.0.1/24 | IoT VLAN Bridge |
| vmbr2 | - | Isolated Network |

---
*Demo-Dokumentation für Proxmox VE Infrastructure*  
*Generiert am: $(date)*  
*Für echte Daten das Hauptscript auf Proxmox ausführen*
EOF

echo "✅ Demo-Dokumentation erstellt: $OUTPUT_FILE"
echo ""
echo "📊 Demo-Infrastruktur:"
echo "   - VMs: 3 (ubuntu-server, windows-10, opnsense)"
echo "   - LXC: 4 (docker-host, web-server, home-assistant, pihole-backup)"
echo "   - Storage: 4 (local, local-lvm, backup-nfs, iso-storage)"
echo "   - Networks: 3 (vmbr0, vmbr1, vmbr2)"
echo ""
echo "🎨 Zum Anzeigen des Demo-Diagramms:"
echo "   - Datei in VS Code mit Mermaid-Extension öffnen"
echo "   - Oder online unter: https://mermaid.live/"
echo ""
echo "⚡ Für echte Proxmox-Daten:"
echo "   ./generate-proxmox-documentation.sh auf dem Proxmox-Server ausführen"