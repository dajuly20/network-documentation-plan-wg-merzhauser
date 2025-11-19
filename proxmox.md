# Proxmox VE Infrastruktur-Dokumentation

Automatisch generiert am: $(date)
Server: $(hostname) ($(hostname -I | awk '{print $1}'))

```mermaid
graph TB
    %% Proxmox Infrastructure Overview
    
    subgraph "Proxmox Cluster"
        CLUSTER["🖥️ Standalone Node: julian-Precision-5550"]

    %% Nodes
        NODE_julian-Precision-5550["🖥️ julian-Precision-5550<br/>Status: online<br/>Uptime: up 1 hour, 37 minutes"]
        CLUSTER --> NODE_julian-Precision-5550

    %% Virtual Machines

    %% LXC Containers

    %% Storage

    %% Network Interfaces
        NET_docker0["🌐 Bridge: docker0<br/>IP: 172.17.0.1/16"]
        CLUSTER --> NET_docker0

    end

    %% Styling
    classDef vmClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef lxcClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef nodeClass fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef storageClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef clusterClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    classDef networkClass fill:#f1f8e9,stroke:#33691e,stroke-width:2px

    %% CSS-Klassen zuweisen
    %% Nodes Styling
    class NODE_julian-Precision-5550 nodeClass
    %% Network Styling
    class NET_docker0 networkClass
    class CLUSTER clusterClass
```

## 📊 Detaillierte Informationen

### 🖥️ System-Informationen
- **Hostname**: julian-Precision-5550
- **IP-Adresse**: 192.168.188.141
- **Uptime**: up 1 hour, 37 minutes
- **Kernel**: 6.8.0-87-generic
- **Proxmox Version**: 

### 🖥️ Virtual Machines

| VMID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|

### 📦 LXC Containers

| CTID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|

### 💾 Storage

| Name | Type | Content | Status |
|------|------|---------|--------|

---
*Automatisch generiert durch Proxmox Documentation Script*  
*Datum: $(date)*  
*Server: $(hostname)*
