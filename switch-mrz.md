# Zyxel XGS1210-12 – Portübersicht `mrz.ip`

```mermaid
flowchart TD
  subgraph Zyxel XGS1210-12
    P1[Fritzbox (VLAN 4)<br>Port 1]
    P2[Schrank-Switch (VLAN 1+4)<br>Port 2]
    P3[Zigbee Pi<br>Port 3<br>VLAN 1]
    P4[Onkyo Receiver<br>Port 4<br>VLAN 1]
    P5[RetroPie<br>Port 5<br>VLAN 1]
    P6[Gerät frei<br>Port 6]
    P7[Gerät frei<br>Port 7]
    P8[Gerät frei<br>Port 8]
    P9[FireTV<br>Port 9<br>VLAN 1]
    P10[Pi-hole<br>Port 10<br>VLAN 1]
    P11[PC „jul“<br>Port 11<br>VLAN 1]
    P12[Gerät unbekannt<br>Port 12]
  end

  Fritzbox --> P1
  P2 --> SwitchSchrank
  P3 --> HomeAssistant
  P4 --> AV
  P5 --> TV
```
