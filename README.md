Sure, here is the updated `readme.md` file that includes the new functionality for monitoring connections and ciphers:

```markdown
# Strongswan-IPSec-Tunnel-Monitoring-Toolkit
A Toolkit for Strongswan / IPSec Tunnel in Linux machines, Can be used in Zabbix as a script.

# Usage:
- Find all tunnels and count them.
- Determine Packet Loss to each tunnel.
- Determine RTT (Round Trip Time) for each tunnel.
- Determine the status of ipsec tunnel in systemd (Openswan and Strongswan).
- Show details of all connections (Remote EAP identities).
- Show SSL ciphers used by all connections.
- Can be used in Zabbix.

# Example usage:
- Count all tunnels:
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh count_all_tunnels
1
```

- Determine packet loss to a certain tunnel:
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh packetloss afranet
0
```

- Determine RTT (Round Trip Time) to a certain tunnel:
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh rtt afranet
6.214
```

- Determine the openswan/strongswan status in systemd (1=running, 0=stopped, crashed):
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh systemd
1
```

- Show details of all connections (Remote EAP identities):
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh connections
tmp_aaanerud
skbjoentegaard
```

- Show SSL ciphers used by all connections:
```
zabbix@StrongSwan1:/etc/zabbix/scripts$ ./strongswan-monitor-toolkit.sh ciphers
AES_CBC_256/HMAC_SHA2_256_128/PRF_HMAC_SHA2_256/ECP_256
AES_CBC_256/HMAC_SHA2_256_128/PRF_HMAC_SHA2_256/MODP_2048
```

# Example Zabbix parameter:
```
UserParameter=count_all_tunnels,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh count_all_tunnels
UserParameter=packetloss_afranet,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh packetloss to-afranet
UserParameter=packetloss_mobinnet,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh packetloss to-Mobinnet
UserParameter=rtt_afranet,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh rtt to-afranet
UserParameter=rtt_mobinnet,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh rtt to-Mobinnet
UserParameter=systemd,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh systemd
UserParameter=connections,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh connections
UserParameter=ciphers,bash /etc/zabbix/scripts/strongswan-monitor-toolkit.sh ciphers
```
- Keep in mind to add Zabbix user in sudoers for ipsec and systemd commands like this (/etc/sudoers):
```
zabbix  ALL=(ALL) NOPASSWD:/usr/sbin/ipsec, NOPASSWD:/bin/systemctl
```

- Increase Zabbix-Agent timeout to 30 seconds. (/etc/zabbix/zabbix_agentd.conf)
```
Timeout=30
```

# Example Zabbix Graph:
- Packetloss to a certain tunnel
![alt Monitor Strongswan ipsec tunnel in Zabbix](https://github.com/danitfk/Strongswan-IPSec-Tunnel-Monitoring-Toolkit/blob/master/graph.png?raw=true)

- RTT to a certain tunnel
![alt Monitor Strongswan ipsec tunnel in Zabbix](https://github.com/danitfk/Strongswan-IPSec-Tunnel-Monitoring-Toolkit/blob/master/graph2.jpg?raw=true)
```

This update includes instructions for the new commands `connections` and `ciphers`, demonstrating how to use them and including them in Zabbix parameters.
