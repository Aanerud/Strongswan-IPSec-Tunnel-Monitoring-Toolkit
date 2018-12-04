# Strongswan-IPSec-Tunnel-Monitoring-Toolkit
A Toolkit for Strongswan / IPSec Tunnel in Linux machines, Can be used in Zabbix as a script.

# Usage:
- Find all tunnels and count them.
- Determine Packet Loss to each tunnel.
- Determine RTT (Round Trip Time) for each tunnel
- Determine the status of ipsec tunnel in systemd (Openswan and Strongswan)
- Can be used in Zabbix.

# Example usage:
- Count all tunnels:

```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh count_all_tunnels`
2
```


- Determine packet loss to a certain tunnel:

```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh packetloss afranet
0
```
- Determine RTT (Round Trip Time) to a certain tunnel.

```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh rtt afranet`
6.214
```


- Determine the openswan/strongswan status in systemd (1=running, 0=stopped,crashed)
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh systemd
1
```

# Example Zabbix parameter:

```
UserParameter=count_all_tunnels,bash /etc/zabbix/strongswan-monitor-toolkit.sh count_all_tunnels
UserParameter=packetloss_afranet,bash /etc/zabbix/strongswan-monitor-toolkit.sh packetloss to-afranet
UserParameter=packetloss_mobinnet,bash /etc/zabbix/strongswan-monitor-toolkit.sh packetloss to-Mobinnet
UserParameter=systemd,bash /etc/zabbix/strongswan-monitor-toolkit.sh systemd
```

# Example Zabbix Graph:

![alt Ansible playbook install zabbix agent on linux server](https://github.com/danitfk/Strongswan-IPSec-Tunnel-Monitoring-Toolkit/blob/master/graph.png?raw=true)

