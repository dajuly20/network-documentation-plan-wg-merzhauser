# Netzwerke & VLANs

| Netz / VLAN      | Zweck        | Router/DHCP               | Besonderheiten        |
|------------------|--------------|---------------------------|-----------------------|
| 192.168.188.0/24 | Heimnetz     | FRITZ!Box                 | Haupt-WLAN / Clients |
| 10.0.0.0/24      | IoT-Netz     | EdgeRouter (bald OPNsense)| Viele feste Leases   |
| VLAN 102         | Admin-Netz   | OPNsense                  | Management / Admin   |
| VLAN 5           | AD/Server    | OPNsense                  | Domain Controller    |
