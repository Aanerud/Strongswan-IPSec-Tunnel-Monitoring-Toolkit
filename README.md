# StrongSwan Monitoring Toolkit

## Author
- Original Author: danitfk (26/Nov/2018)
- Current Author: Andreas Martin Aanerud (08/Jun/2024)

This toolkit provides scripts and configuration files to monitor StrongSwan IKEv2 VPN tunnels. It is designed to be used standalone or integrated with Zabbix for comprehensive monitoring and alerting.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Zabbix Integration](#zabbix-integration)
- [Common Issues](#common-issues)

## Features

- Count all running VPN tunnels.
- Display systemd status of StrongSwan.
- Check packet loss and RTT to the endpoint for specified users.
- Show connection details, including SSL ciphers and connection time.
- Zabbix integration for automated monitoring and alerting.

## Requirements

- StrongSwan installed and configured.
- Zabbix agent installed (for Zabbix integration).
- Linux environment with `awk`, `ping`, and `sudo` installed.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Aanerud/strongswan-monitor-toolkit.git
   cd strongswan-monitor-toolkit
   ```

2. **Copy the script to the appropriate directory:**
   ```bash
   sudo cp strongswan-monitor-toolkit.sh /etc/zabbix/scripts/
   ```

3. **Set the appropriate permissions:**
   ```bash
   sudo chown -R root:zabbix /etc/zabbix/
   sudo chmod -R 750 /etc/zabbix/
   ```

4. **Edit sudoers file to allow Zabbix to run the script without a password:**
   ```bash
   sudo visudo
   ```

   Add the following lines:
   ```
   zabbix ALL=(ALL) NOPASSWD:/usr/sbin/ipsec, NOPASSWD:/bin/systemctl, NOPASSWD:/etc/zabbix/scripts/strongswan-monitor-toolkit.sh
   ```

## Usage

### Standalone Script

To use the script standalone, you can run it with the appropriate action. Below are examples of how to use each action:

- **Count all running tunnels:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh count_all_tunnels
  ```

- **Check packet loss for a user:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh packetloss username
  ```

- **Check RTT for a user:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh rtt username
  ```

- **Check systemd service status of StrongSwan:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh systemd
  ```

- **Show details of all connections:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh connections
  ```

- **Show SSL ciphers used by a specified user:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh ciphers username
  ```

- **Show connection time of a specified user:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh connection_time username
  ```

- **Discover all active connections:**
  ```bash
  sudo /etc/zabbix/scripts/strongswan-monitor-toolkit.sh discovery
  ```

### Zabbix Integration

1. **Import the Zabbix template:**
   - Navigate to Zabbix web interface -> Configuration -> Templates -> Import
   - Select the `zabbix_strongswan.yaml` file and import it.

2. **Copy the Zabbix user parameters configuration file:**
   ```bash
   sudo cp strongswan_userparameters.conf /etc/zabbix/zabbix_agentd.d/
   ```

3. **Restart the Zabbix agent:**
   ```bash
   sudo systemctl restart zabbix-agent
   ```

4. **Assign the template to the host in Zabbix:**
   - Navigate to Zabbix web interface -> Configuration -> Hosts
   - Select the desired host -> Templates -> Link new templates
   - Link the `Template VPN StrongSwan` template.

## Common Issues

- **Permission Denied:**
  Ensure that the script has the correct permissions and the sudoers file is configured correctly.

- **Zabbix Agent Cannot Execute Script:**
  Verify that the Zabbix agent has the correct permissions and can execute the script without requiring a password.

- **Incorrect Data or No Data in Zabbix:**
  Ensure that the user parameters are correctly configured and that the Zabbix template items and discovery rules are correctly set up.

By following these instructions, you can monitor your StrongSwan IKEv2 VPN tunnels effectively using the provided toolkit and Zabbix integration.
