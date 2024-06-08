# Strongswan IPSec Tunnel Monitoring Toolkit
This toolkit provides a set of scripts to monitor and debug Strongswan IPSec tunnels, making it easier for sysadmins to track and debug VPN connections.

## Author
- Original Author: danitfk (26/Nov/2018)
- Current Author: Andreas Martin Aanerud (08/Jun/2024)

## Features
- Count all running tunnels
- Check packet loss to the endpoint
- Determine RTT (Round Trip Time) to the endpoint
- Check the status of the StrongSwan systemd service
- Show details of all connections
- Show SSL ciphers used by a specified user
- Show connection time of a specified user
- Discover all active connections

## Usage
You need to declare at least one action. Below are the available commands:

### Count all running tunnels
```sh
./strongswan-monitor-toolkit.sh count_all_tunnels
```

### Check packet loss to the endpoint
```sh
./strongswan-monitor-toolkit.sh packetloss [username]
```

### Determine RTT to the endpoint
```sh
./strongswan-monitor-toolkit.sh rtt [username]
```

### Check systemd service of StrongSwan
```sh
./strongswan-monitor-toolkit.sh systemd
```

### Show details of all connections
```sh
./strongswan-monitor-toolkit.sh connections
```

### Show SSL ciphers used by the specified user
```sh
./strongswan-monitor-toolkit.sh ciphers [username]
```

### Show connection time of the specified user
```sh
./strongswan-monitor-toolkit.sh connection_time [username]
```

### Discover all active connections
```sh
./strongswan-monitor-toolkit.sh discovery
```

## Detailed Command Descriptions

### count_all_tunnels
Counts and outputs the number of currently running tunnels.

### packetloss
Checks packet loss to the specified user's endpoint and outputs the average packet loss percentage.

#### Example:
```sh
./strongswan-monitor-toolkit.sh packetloss john_doe
```

### rtt
Determines and outputs the average RTT to the specified user's endpoint.

#### Example:
```sh
./strongswan-monitor-toolkit.sh rtt john_doe
```

### systemd
Checks the status of the StrongSwan systemd service. Outputs `1` if the service is running, `0` otherwise.

### connections
Lists details of all connections.

### ciphers
Shows the SSL ciphers used by the specified user.

#### Example:
```sh
./strongswan-monitor-toolkit.sh ciphers john_doe
```

### connection_time
Shows the connection time of the specified user.

#### Example:
```sh
./strongswan-monitor-toolkit.sh connection_time john_doe
```

### discovery
Discovers and outputs all active connections in a JSON format.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing
Feel free to open issues or submit pull requests for any enhancements or bug fixes.

## Acknowledgements
- Original script by danitfk.
- Enhanced and maintained by Andreas Martin Aanerud.
```

This README file covers the purpose of the toolkit, how to use it, and a brief description of each command, providing clear and concise information for any user looking to understand or utilize your script.
