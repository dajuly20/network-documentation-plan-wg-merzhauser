# 🏠 WG Merzhauser - Netzwerk Infrastrukturdokumentation

> **Vollständige Dokumentation der Heimnetz-Infrastruktur**  
> Erstellt am: 19. November 2025  
> Server: Julian Wiche Netzwerk

---

## 📋 Inhaltsverzeichnis

1. [🌐 Netzwerk-Übersicht](#-netzwerk-übersicht)
2. [🌐 DNS-Infrastruktur](#-dns-infrastruktur) → [Details](DNS-CONFIG.md)
3. [🔒 Firewall & Routing](#-firewall--routing-konfiguration) → [Details](FIREWALL-CONFIG.md)
4. [🔒 VPN-Verbindungen](#-vpn-verbindungen) → [Details](VPN-CONFIG.md)
5. [🔌 Switch-Konfiguration](#-switch-konfiguration)
6. [📡 IP-Adressen & Geräte](#-ip-adressen--geräte)
7. [💻 Proxmox-Infrastruktur](#-proxmox-infrastruktur) → [Details](PROXMOX-README.md)
8. [🌐 Web-Interfaces](#-web-interfaces)
9. [📊 Automatisierung](#-automatisierung) → [Details](AUTOMATION.md)
10. [🏷️ Domain-Übersicht](#️-domain-übersicht)
11. [📋 Zusammenfassung](#-zusammenfassung)
12. [📞 Support & Wartung](#-support--wartung)

---
## 🌐 Netzwerk-Übersicht

### 🏗️ Infrastructure-Diagramm

```mermaid
graph TB
    INTERNET([🌍 Internet<br/>Glasfaser 1,1 Gbit/s])

    INTERNET ==> FRITZBOX

    subgraph edge [🔒 Edge Security Zone]
        FRITZBOX[🔵 FritzBox 5590<br/>192.168.188.1<br/>box.mrz.ip]
        FIREWALL[🛡️ OPNsense Firewall<br/>192.168.188.254<br/>opensence.mrz.ip]
        FRITZBOX ==> FIREWALL
    end

    FIREWALL ==> SWITCH

    subgraph core [⚙️ Core Network Infrastructure]
        SWITCH[🔶 Zyxel XGS1210-12<br/>2.5G Core Switch]
        PIHOLE[🔴 Pi-hole DNS<br/>192.168.188.2<br/>pihole.mrz.ip]
        SWITCH --> PIHOLE
    end

    subgraph servers [💻 Server & Virtualization Zone]
        PVE[🟢 Proxmox VE<br/>192.168.188.177<br/>pve.mrz.ip]
        PVE_BACKUP[🟢 Proxmox Backup<br/>192.168.188.156]
        PVE_DOCKER[🟢 Proxmox Docker<br/>192.168.188.179]
        PROXY[🔷 Reverse Proxy<br/>proxy.mrz.ip]
    end

    SWITCH --> PVE
    SWITCH --> PVE_BACKUP
    SWITCH --> PVE_DOCKER
    SWITCH --> PROXY

    subgraph iot [🏠 IoT & Smart Home Zone - Secured by OPNsense]
        HOMEASSISTANT[🏠 Home Assistant<br/>192.168.188.178]
        SHELLY1[💡 Shelly Monitor<br/>192.168.188.24]
        SHELLY2[💡 Shelly Universum<br/>192.168.188.123]
        SHELLY3[💡 Shelly Lichtschalter<br/>192.168.188.155]
    end

    FIREWALL ==> HOMEASSISTANT
    FIREWALL ==> SHELLY1
    FIREWALL ==> SHELLY2
    FIREWALL ==> SHELLY3

    subgraph network [📡 Network Equipment]
        CORE_SWITCH[🔶 Core Switch<br/>192.168.188.54]
        HELPER_SWITCH[🔶 Helper Switch<br/>192.168.188.57]
        UNIFI_AP[📡 UniFi U6 Pro<br/>192.168.188.61]
        FRITZBOX_AP[📡 FritzBox 7490 AP<br/>192.168.188.79]
    end

    SWITCH --> CORE_SWITCH
    SWITCH --> HELPER_SWITCH
    SWITCH --> UNIFI_AP
    SWITCH --> FRITZBOX_AP

    subgraph media [📺 Media & Entertainment]
        FIRETV1[📺 FireTV Julian<br/>192.168.188.149]
        FIRETV2[📺 FireTV Wohnzimmer<br/>192.168.188.102]
        ONKYO[🔊 Onkyo Receiver<br/>192.168.188.173]
        SONY[🔊 Sony Receiver<br/>192.168.188.162]
        VOLUMIO[🎵 Volumio<br/>192.168.188.96]
    end

    SWITCH --> FIRETV1
    SWITCH --> FIRETV2
    SWITCH --> ONKYO
    SWITCH --> SONY
    SWITCH --> VOLUMIO

    classDef internetClass fill:#e1f5fe,stroke:#01579b,stroke-width:4px
    classDef routerClass fill:#e3f2fd,stroke:#1565c0,stroke-width:3px
    classDef firewallClass fill:#fff3e0,stroke:#e65100,stroke-width:4px
    classDef switchClass fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef serverClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef dnsClass fill:#ffebee,stroke:#c62828,stroke-width:2px
    classDef iotClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef mediaClass fill:#f1f8e9,stroke:#558b2f,stroke-width:2px
    classDef networkClass fill:#fff9c4,stroke:#f57f17,stroke-width:2px
    classDef proxyClass fill:#e0f2f1,stroke:#00695c,stroke-width:2px

    class INTERNET internetClass
    class FRITZBOX routerClass
    class FIREWALL firewallClass
    class SWITCH,CORE_SWITCH,HELPER_SWITCH switchClass
    class PVE,PVE_BACKUP,PVE_DOCKER serverClass
    class PIHOLE dnsClass
    class HOMEASSISTANT,SHELLY1,SHELLY2,SHELLY3 iotClass
    class FIRETV1,FIRETV2,ONKYO,SONY,VOLUMIO mediaClass
    class UNIFI_AP,FRITZBOX_AP networkClass
    class PROXY proxyClass
```

---


## 🌐 DNS-Infrastruktur

**Pi-hole DNS Server** - Zentrale DNS-Verwaltung mit Ad-Blocking

- **Server**: 192.168.188.2 (pihole.mrz.ip / wg.weis.er)
- **Web-Interface**: [http://wg.weis.er/](http://wg.weis.er/) | [http://192.168.188.2/](http://192.168.188.2/)
- **Upstream DNS**: Cloudflare (1.1.1.1), Google (8.8.8.8)
- **Lokale Zonen**: *.mrz.ip, *.julianw.ip
- **Statistiken**: ~10.000 Queries/Tag, 25-30% geblockt

### Wichtige DNS-Einträge:
- box.mrz.ip → 192.168.188.1 (FritzBox)
- pve.mrz.ip → 192.168.188.177 (Proxmox VE)
- opensence.mrz.ip → 192.168.188.254 (OPNsense)

📖 **[Vollständige DNS-Konfiguration →](DNS-CONFIG.md)**

---

## 🔒 Firewall & Routing Konfiguration

**Zweischichtige Firewall-Architektur** mit FritzBox und OPNsense

- **Layer 1**: FritzBox 5590 (192.168.188.1) - NAT, VPN, Port Forwarding
- **Layer 2**: OPNsense (192.168.188.254) - IoT Isolation, IDS/IPS
- **Static Route**: 10.0.0.0/24 → 192.168.188.254 (IoT VLAN)

### Security Features:
- ✅ IoT-Geräte isoliert in separatem VLAN (10.0.0.0/24)
- ✅ Intrusion Detection/Prevention (IDS/IPS)
- ✅ Traffic Shaping & QoS
- ✅ GeoIP Blocking

📖 **[Vollständige Firewall-Konfiguration →](FIREWALL-CONFIG.md)**

---

| IP-Adresse | Hostname | Beschreibung | MAC-Adresse |
|------------|----------|--------------|-------------|
| `192.168.188.73` | JulianPhillipsTV | Philips TV | 0C:CA:FB:17:A6:4A |
| `192.168.188.96` | volumio | Volumio Audio System | D8:3A:DD:B4:43:B1 |
| `192.168.188.102` | amazon-firetv-wohnzimmer | FireTV Wohnzimmer | C8:4D:44:35:D2:DE |
| `192.168.188.149` | amazon-firetv-julian | FireTV Julian | 00:00:00:00:02:BB |
| `192.168.188.162` | sony-receiver | Sony Receiver | D8:D4:3C:4A:47:3D |
| `192.168.188.173` | onkyo-mrz-ip | Onkyo Receiver | 00:09:B0:E6:C1:95 |

---

## 🔒 VPN-Verbindungen

### VPN-Übersicht

```mermaid
graph TB
    subgraph "VPN-Infrastruktur"
        FRITZBOX_VPN[🔵 FritzBox 5590<br/>VPN Server<br/>192.168.188.1]
        
        subgraph "Wireguard VPN (192.168.188.205-219)"
            WG1[💻 JulSrv1000<br/>192.168.188.205]
            WG2[💻 JulSrvNew<br/>192.168.188.207]
            WG3[💻 ArbeitslaptopLinux<br/>192.168.188.208]
            WG4[💻 Arbeitslaptop<br/>192.168.188.209]
            WG5[📱 JuliansHandy<br/>192.168.188.210]
            WG6[💻 RomisExKrikoLaptop<br/>192.168.188.211]
            WG7[🧪 TestClone<br/>192.168.188.212]
            WG8[🧪 TestClone2<br/>192.168.188.213]
            WG9[🌐 new.julianw.de<br/>192.168.188.214]
            WG10[📱 juli-ueberall<br/>192.168.188.215]
            WG11[💻 Dell Precision 2025<br/>192.168.188.216]
            WG12[💻 New Work Laptop<br/>192.168.188.217]
            WG13[🧪 Test Client<br/>192.168.188.218]
            WG14[💻 Dell Precision 5550<br/>192.168.188.219]
        end
        
        subgraph "IPSec VPN (192.168.188.201-206)"
            IPSEC1[🖥️ JulSrv<br/>192.168.188.201]
            IPSEC2[👤 Johannes Fries<br/>192.168.188.202]
            IPSEC3[👤 julian<br/>192.168.188.203]
            IPSEC4[📱 Box2Go<br/>192.168.188.204]
            IPSEC5[🌐 Lisasupertramp.de<br/>192.168.188.206]
        end
        
        FRITZBOX_VPN --> WG1
        FRITZBOX_VPN --> WG2
        FRITZBOX_VPN --> WG3
        FRITZBOX_VPN --> WG4
        FRITZBOX_VPN --> WG5
        FRITZBOX_VPN --> WG6
        FRITZBOX_VPN --> WG7
        FRITZBOX_VPN --> WG8
        FRITZBOX_VPN --> WG9
        FRITZBOX_VPN --> WG10
        FRITZBOX_VPN --> WG11
        FRITZBOX_VPN --> WG12
        FRITZBOX_VPN --> WG13
        FRITZBOX_VPN --> WG14
        
        FRITZBOX_VPN --> IPSEC1
        FRITZBOX_VPN --> IPSEC2
        FRITZBOX_VPN --> IPSEC3
        FRITZBOX_VPN --> IPSEC4
        FRITZBOX_VPN --> IPSEC5
    end

    classDef wireguardClass fill:#e8f5e8,stroke:#4caf50,stroke-width:2px
    classDef ipsecClass fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    classDef serverClass fill:#fff3e0,stroke:#ff9800,stroke-width:3px

    class WG1,WG2,WG3,WG4,WG5,WG6,WG7,WG8,WG9,WG10,WG11,WG12,WG13,WG14 wireguardClass
    class IPSEC1,IPSEC2,IPSEC3,IPSEC4,IPSEC5 ipsecClass
    class FRITZBOX_VPN serverClass
```

### 📋 VPN-Client-Tabellen

#### Wireguard VPN-Clients
| VPN-IP | Client-Name | Typ | Beschreibung |
|--------|-------------|-----|--------------|
| 192.168.188.205 | JulSrv1000 | Server | Server 1000 |
| 192.168.188.207 | JulSrvNew | Server | Neuer Server |
| 192.168.188.208 | ArbeitslaptopLinux | Laptop | Work Laptop Linux |
| 192.168.188.209 | Arbeitslaptop | Laptop | Work Laptop |
| 192.168.188.210 | JuliansHandy | Mobile | Julian's Phone |
| 192.168.188.211 | RomisExKrikoLaptop | Laptop | Romi's Laptop |
| 192.168.188.212 | JulianW.de-TestfutureClone | Test | Test Clone |
| 192.168.188.213 | JulianwDeTestClone2 | Test | Test Clone 2 |
| 192.168.188.214 | new.julianw.de | Server | New Server |
| 192.168.188.215 | juli-ueberall | Mobile | Julian Mobile |
| 192.168.188.216 | neuerDellPrecsicion2025 | Laptop | Dell Precision 2025 |
| 192.168.188.217 | ArbeitsLaptopNeu | Laptop | New Work Laptop |
| 192.168.188.218 | ttt | Test | Test Client |
| 192.168.188.219 | NeuerDellPrecsicion5550 | Laptop | Dell Precision 5550 |

#### IPSec VPN-Clients
| VPN-IP | Client-Name | Typ | Beschreibung |
|--------|-------------|-----|--------------|
| 192.168.188.201 | JulSrv | Server | Hauptserver |
| 192.168.188.202 | Johannes Fries | User | Johannes |
| 192.168.188.203 | julian | User | Julian |
| 192.168.188.204 | Box2Go | Mobile | Mobile Box |
| 192.168.188.206 | Lisasupertramp.de | Server | Lisa's Server |

---

## 💻 Proxmox-Infrastruktur

### Proxmox-Cluster Übersicht

```mermaid
graph TB
    subgraph "Proxmox Cluster: homelab"
        
        %% Cluster
        CLUSTER[🏢 Cluster: homelab]
        
        %% Nodes
        NODE_pve[🖥️ pve.mrz.ip<br/>192.168.188.177<br/>Status: online<br/>Uptime: 15+ days<br/>Web: https://192.168.188.177:8006/]
        NODE_pve2[🖥️ pve-backup.mrz.ip<br/>192.168.188.156<br/>Status: online<br/>Uptime: 12+ days<br/>Backup Focus]
        NODE_pve3[🖥️ proxmox-docker<br/>192.168.188.179<br/>Status: online<br/>Container Focus]
        
        CLUSTER --> NODE_pve
        CLUSTER --> NODE_pve2  
        CLUSTER --> NODE_pve3
        
        %% Virtual Machines
        VM_100[🖥️ VM 100: ubuntu-server<br/>Status: running<br/>OS: ubuntu<br/>RAM: 4096MB<br/>CPU: 4 Cores<br/>Disk: local-lvm:vm-100]
        VM_101[🖥️ VM 101: windows-10<br/>Status: stopped<br/>OS: win10<br/>RAM: 8192MB<br/>CPU: 6 Cores<br/>Disk: local-lvm:vm-101]
        VM_102[🖥️ VM 102: opnsense-firewall<br/>Status: running<br/>OS: firewall<br/>RAM: 2048MB<br/>CPU: 2 Cores<br/>Disk: local-lvm:vm-102]
        VM_103[🖥️ VM 103: home-assistant<br/>Status: running<br/>OS: debian<br/>RAM: 1024MB<br/>CPU: 1 Core<br/>Disk: local-lvm:vm-103]
        
        NODE_pve --> VM_100
        NODE_pve --> VM_101
        NODE_pve --> VM_102
        NODE_pve2 --> VM_103
        
        %% LXC Containers
        LXC_200[📦 CT 200: docker-host<br/>Status: running<br/>OS: ubuntu<br/>RAM: 2048MB<br/>CPU: 2 Cores<br/>Storage: local-lvm:vm-200-disk-0]
        LXC_201[📦 CT 201: web-server<br/>Status: running<br/>OS: debian<br/>RAM: 1024MB<br/>CPU: 2 Cores<br/>Storage: local-lvm:vm-201-disk-0]
        LXC_202[📦 CT 202: proxy-server<br/>Status: running<br/>OS: debian<br/>RAM: 512MB<br/>CPU: 1 Core<br/>Storage: local-lvm:vm-202-disk-0]
        LXC_203[📦 CT 203: pihole-backup<br/>Status: stopped<br/>OS: debian<br/>RAM: 512MB<br/>CPU: 1 Core<br/>Storage: local-lvm:vm-203-disk-0]
        LXC_204[📦 CT 204: monitoring<br/>Status: running<br/>OS: debian<br/>RAM: 1024MB<br/>CPU: 1 Core<br/>Storage: local-lvm:vm-204-disk-0]
        
        NODE_pve --> LXC_200
        NODE_pve --> LXC_201
        NODE_pve2 --> LXC_202
        NODE_pve2 --> LXC_203
        NODE_pve3 --> LXC_204
        
        %% Storage
        STORAGE_local[💾 Storage: local<br/>Type: dir<br/>Content: iso,backup]
        STORAGE_local_lvm[💾 Storage: local-lvm<br/>Type: lvmthin<br/>Content: images,rootdir]
        STORAGE_backup[💾 Storage: backup-nfs<br/>Type: nfs<br/>Content: backup]
        STORAGE_iso[💾 Storage: iso-storage<br/>Type: nfs<br/>Content: iso,vztmpl]
        
        CLUSTER --> STORAGE_local
        CLUSTER --> STORAGE_local_lvm
        CLUSTER --> STORAGE_backup
        CLUSTER --> STORAGE_iso
        
        %% Network
        NET_vmbr0[🌐 Bridge: vmbr0<br/>192.168.188.177/24<br/>Main Network]
        NET_vmbr1[🌐 Bridge: vmbr1<br/>10.0.0.1/24<br/>IoT Network]
        NET_vmbr2[🌐 Bridge: vmbr2<br/>Isolated<br/>DMZ Network]
        
        CLUSTER --> NET_vmbr0
        CLUSTER --> NET_vmbr1
        CLUSTER --> NET_vmbr2
    end

    %% Styling
    classDef vmClass fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef lxcClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef nodeClass fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef storageClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef clusterClass fill:#fce4ec,stroke:#880e4f,stroke-width:3px
    classDef networkClass fill:#f1f8e9,stroke:#33691e,stroke-width:2px

    %% VMs Styling
    class VM_100,VM_101,VM_102,VM_103 vmClass
    
    %% LXC Styling
    class LXC_200,LXC_201,LXC_202,LXC_203,LXC_204 lxcClass
    
    %% Nodes Styling
    class NODE_pve,NODE_pve2,NODE_pve3 nodeClass
    
    %% Storage Styling
    class STORAGE_local,STORAGE_local_lvm,STORAGE_backup,STORAGE_iso storageClass
    
    %% Network Styling
    class NET_vmbr0,NET_vmbr1,NET_vmbr2 networkClass
    
    %% Cluster
    class CLUSTER clusterClass
```

### 📊 Proxmox Ressourcen-Übersicht

#### Virtual Machines

| VMID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
| 100 | ubuntu-server | ✅ running | 4096MB | 4 Cores | local-lvm:vm-100 | ubuntu |
| 101 | windows-10 | ⏸️ stopped | 8192MB | 6 Cores | local-lvm:vm-101 | win10 |
| 102 | opnsense-firewall | ✅ running | 2048MB | 2 Cores | local-lvm:vm-102 | firewall |
| 103 | home-assistant-vm | ✅ running | 1024MB | 1 Core | local-lvm:vm-103 | debian |

#### LXC Containers


## 🔒 VPN-Verbindungen

**FritzBox VPN Server** - Wireguard & IPSec

- **Wireguard VPN**: 14 Clients (192.168.188.205-219)
- **IPSec VPN**: 5 Clients (192.168.188.201-206)
- **Port**: 51820 UDP (Wireguard), 500/4500 UDP (IPSec)
- **DynDNS**: MyFRITZ! aktiviert

📖 **[Vollständige VPN-Konfiguration →](VPN-CONFIG.md)**

---
| CTID | Name | Status | Memory | CPU | Storage | OS |
|------|------|--------|--------|-----|---------|-----|
| 200 | docker-host | ✅ running | 2048MB | 2 Cores | local-lvm:vm-200-disk-0 | ubuntu |
| 201 | web-server | ✅ running | 1024MB | 2 Cores | local-lvm:vm-201-disk-0 | debian |
| 202 | proxy-server | ✅ running | 512MB | 1 Core | local-lvm:vm-202-disk-0 | debian |
| 203 | pihole-backup | ⏸️ stopped | 512MB | 1 Core | local-lvm:vm-203-disk-0 | debian |
| 204 | monitoring | ✅ running | 1024MB | 1 Core | local-lvm:vm-204-disk-0 | debian |

#### Storage-Systeme

| Name | Type | Content | Status | Beschreibung |
|------|------|---------|--------|--------------|
| local | dir | iso,backup | ✅ enabled | Local Directory Storage |
| local-lvm | lvmthin | images,rootdir | ✅ enabled | LVM Thin Provisioning |
| backup-nfs | nfs | backup | ✅ enabled | NFS Backup Storage |
| iso-storage | nfs | iso,vztmpl | ✅ enabled | ISO & Templates Storage |

#### Network Bridges

| Bridge | IP-Adresse | VLAN | Beschreibung |
|--------|-----------|------|--------------|
| vmbr0 | 192.168.188.177/24 | Main | Haupt-Netzwerk-Bridge |
| vmbr1 | 10.0.0.1/24 | IoT | IoT VLAN Bridge |
| vmbr2 | - | DMZ | Isolierte DMZ Bridge |

#### System-Informationen

| Parameter | Wert |
|-----------|------|
| **Cluster-Name** | homelab |
| **Proxmox Version** | pve-manager/8.1.4/ec5affc9e2e6c001 |
| **Kernel** | 6.8.12-1-pve |
| **Hauptnode Uptime** | 15+ Tage |
| **Backup-Node Uptime** | 12+ Tage |
| **Aktive VMs** | 3 von 4 (75%) |
| **Aktive Container** | 4 von 5 (80%) |

---

## 🌐 Web-Interfaces

### 🔧 Management-URLs

| Service | URL | IP-Adresse | Beschreibung | Zugangsdaten |
|---------|-----|------------|--------------|--------------|
| **FritzBox Router** | http://192.168.188.1/ | 192.168.188.1 | Router-Management | Web-Interface |
| **Pi-hole DNS** | http://wg.weis.er/ | 192.168.188.2 | DNS-Management | Admin-Panel |
| **Reverse Proxy** | http://proxy.mrz.ip/ | TBD | Proxy-Management | Load Balancer |
| **Proxmox VE** | https://192.168.188.177:8006/ | 192.168.188.177 | Virtualisierung | Web-Console |
| **OPNsense Firewall** | http://opensence.mrz.ip/ | 192.168.188.254 | Firewall-Management | Web-GUI |
| **IoT VLAN Gateway** | http://10.0.0.254/ | 10.0.0.254 | IoT-Management | Gateway-Config |

### 📱 Quick-Access Dashboard

#### 🎛️ Network Control Center

**🔴 Pi-hole DNS:**
- [http://wg.weis.er/](http://wg.weis.er/) - Pi-hole Admin Interface
- [http://192.168.188.2/](http://192.168.188.2/) - Pi-hole direkte IP

---

```mermaid
graph LR
    subgraph "Management Dashboard"
        DASHBOARD[🎛️ Network Control Center]
        
        ROUTER[🔵 Router<br/>FritzBox<br/>192.168.188.1]
        DNS[🔴 DNS<br/>Pi-hole<br/>wg.weis.er]
        PROXY[🟡 Proxy<br/>Reverse Proxy<br/>proxy.mrz.ip]
        PROXMOX[🟢 Virtualization<br/>Proxmox<br/>:8006]
        FIREWALL[🟠 Security<br/>OPNsense<br/>:254]
        
        DASHBOARD --> ROUTER
        DASHBOARD --> DNS
        DASHBOARD --> PROXY
        DASHBOARD --> PROXMOX
        DASHBOARD --> FIREWALL
        
        %% Quick Actions
        ROUTER --> ROUTER_ACTIONS[📊 Bandwidth Monitor<br/>🔒 Port Forwarding<br/>📱 Device Management]
        DNS --> DNS_ACTIONS[🚫 Block Lists<br/>📈 Query Analytics<br/>⚙️ Local DNS]
        PROXY --> PROXY_ACTIONS[🔄 Load Balancing<br/>🔒 SSL Termination<br/>🎯 Service Routing]
        PROXMOX --> PROXMOX_ACTIONS[🖥️ VM Management<br/>📦 Container Control<br/>💾 Backup Monitor]
        FIREWALL --> FIREWALL_ACTIONS[🔥 Traffic Rules<br/>🛡️ Intrusion Detection<br/>📊 Threat Analysis]
    end

    classDef dashboardClass fill:#f8f9fa,stroke:#343a40,stroke-width:3px
    classDef serviceClass fill:#e3f2fd,stroke:#1976d2,stroke-width:2px
    classDef actionClass fill:#f1f8e9,stroke:#388e3c,stroke-width:1px

    class DASHBOARD dashboardClass
    class ROUTER,DNS,PROXY,PROXMOX,FIREWALL serviceClass
    class ROUTER_ACTIONS,DNS_ACTIONS,PROXY_ACTIONS,PROXMOX_ACTIONS,FIREWALL_ACTIONS actionClass
```

---

## 📊 Automatisierung

### 🤖 Proxmox Auto-Documentation Script

Das Repository enthält ein automatisiertes Script zur Generierung der Proxmox-Dokumentation:

#### Script-Features:
- **Automatische Erkennung** aller VMs und LXC Container
- **Mermaid-Diagramm-Generierung** der gesamten Infrastruktur
- **Detaillierte Tabellen** mit Hardware-Konfiguration
- **Storage- und Netzwerk-Analyse**
- **Cluster-Status-Monitoring**

#### Verwendung:
```bash
# Auf Proxmox-Server ausführen
chmod +x generate-proxmox-documentation.sh
./generate-proxmox-documentation.sh

# Generiert: proxmox.md mit aktueller Infrastruktur
```

#### Automatisierung per Cron:
```bash
# Tägliche Dokumentations-Updates um 2 Uhr
0 2 * * * /path/to/generate-proxmox-documentation.sh

# Ausgabe nach Git pushen (optional)
5 2 * * * cd /path/to/repo && git add . && git commit -m "Auto-update $(date)" && git push
```

### 📊 Mermaid-Diagramm Automatisierung

Alle Netzwerk-Diagramme in dieser Dokumentation werden als Mermaid-Code in `.mmd`-Dateien gespeichert und automatisch zu Bildern gerendert.

#### 🗂️ Diagramm-Struktur

```
docs/claude/diagrams/
├── infrastructure.mmd          # Haupt-Infrastruktur-Diagramm
├── dns-flow.mmd               # DNS & Pi-hole Flow
├── firewall-architecture.mmd  # Firewall & Routing
├── switch-ports.mmd           # Switch-Konfiguration (falls vorhanden)
├── vpn-topology.mmd           # VPN-Übersicht
└── ... (weitere Diagramme)
```

#### 🔧 Diagramme Generieren

**Alle Diagramme neu erstellen:**
```bash
cd docs/claude
make diagrams
```

**Nur veränderte Diagramme neu erstellen:**
```bash
# Make erkennt automatisch geänderte .mmd-Dateien
# und generiert nur diese neu (basierend auf Datei-Timestamps)
cd docs/claude
make diagrams
```

**Einzelnes Diagramm erstellen:**
```bash
cd docs/claude
make diagrams/infrastructure.png    # Nur PNG
make diagrams/infrastructure.svg    # Nur SVG

# Oder manuell mit mmdc:
mmdc -i diagrams/infrastructure.mmd -o diagrams/infrastructure.png
```

**Alle generierten Bilder löschen:**
```bash
cd docs/claude
make clean
```

#### 📝 Diagramme in Markdown Einbinden

**Option 1: Live-Rendering mit Mermaid.js (Web)**
```markdown
```mermaid
graph TB
    A[Node A] --> B[Node B]
```
```

**Option 2: Statische Bilder (für PDF/Print)**
```markdown
![Infrastructure Diagram](docs/claude/diagrams/infrastructure.png)
```

**Option 3: Beide Varianten kombinieren**
```markdown
<!-- Mermaid-Code für Web-Ansicht -->
```mermaid
graph TB
    A[Node A] --> B[Node B]
```

<!-- Alternativ: Bild für PDF/Export -->
![Fallback](docs/claude/diagrams/infrastructure.png)
```

## 📊 Automatisierung

**Automatische Dokumentations-Generierung und Diagramm-Rendering**

### 🤖 Proxmox Auto-Documentation
- Automatische Erkennung aller VMs/Container
- Mermaid-Diagramm-Generierung
- Cron-Job fähig

### 📊 Mermaid-Diagramme
- Alle Diagramme in `docs/claude/diagrams/*.mmd`
- Automatische PNG/SVG-Generierung via `make diagrams`
- Git Pre-Commit Hook für Auto-Update
- GitHub Actions für CI/CD

### 🔄 Workflow:
```bash
# Diagramme generieren (nur geänderte)
cd docs/claude && make diagrams

# Commit mit Auto-Generierung
git commit -m "Update diagrams"  # Hook generiert automatisch
```

📖 **[Vollständige Automatisierungs-Dokumentation →](AUTOMATION.md)**

---
