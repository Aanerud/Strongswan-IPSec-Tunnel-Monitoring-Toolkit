#!/bin/bash
# Author: danitfk - aanerud
# Date: 07/June/2024

function print_help {
    echo "You have to declare at least one action"
    echo "Help :"
    echo ""
    echo "./strongswan-monitor-toolkit.sh count_all_tunnels"
    echo "    -> Count all running tunnels."
    echo ""
    echo "./strongswan-monitor-toolkit.sh packetloss [tunnel_name]"
    echo "    -> Check packetloss to endpoint (other side of tunnel) then show the avg."
    echo ""
    echo "./strongswan-monitor-toolkit.sh rtt [tunnel_name]"
    echo "    -> Determine RTT to endpoint (other side of tunnel) then show the avg."
    echo ""
    echo "./strongswan-monitor-toolkit.sh systemd"
    echo "    -> Check systemd service of strongswan"
    echo ""
    echo "./strongswan-monitor-toolkit.sh connections"
    echo "    -> Show details of all connections."
    echo ""
    echo "./strongswan-monitor-toolkit.sh ciphers"
    echo "    -> Show SSL ciphers used by all connections."
}

if [[ "$1" == "count_all_tunnels" ]]; then
    sudo ipsec status | awk {'print $1'} | grep -v 'Security' | cut -d "{" -f1 | cut -d "[" -f1 | uniq | wc -l
    exit 0
fi

if [[ "$1" == "packetloss" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Tunnel name is empty."
        echo "Available tunnel names: "
        tunnels_name=`sudo ipsec status | awk {'print $1'}  | cut -d"[" -f1 | cut -d"{" -f1  | sort | uniq | grep -v "Security"`
        echo $tunnels_name
        exit 1
    fi
    export tunnel_name="$2"
    tunnel_endpoint_ip=`sudo ipsec status | grep -i $tunnel_name | grep -o "===.*" | awk {'print $2'} | cut -d"/" -f1`
    if [ "$tunnel_endpoint_ip" = "" ]; then
        echo "Tunnel does not exists"
        exit 1
    fi
    ping $tunnel_endpoint_ip -c 50 -i 0.2 -W1 > /tmp/ping_status
    packet_loss_percentage=`cat /tmp/ping_status | grep loss | awk {'print $6'} | sed 's/%//g'`
    echo "$packet_loss_percentage"
    exit 0
fi

if [ "$1" == "rtt" ]; then
    if [[ "$2" == "" ]]; then
        echo "Tunnel name is empty."
        echo "Available tunnel names: "
        tunnels_name=`sudo ipsec status | awk {'print $1'}  | cut -d"[" -f1 | cut -d"{" -f1  | sort | uniq | grep -v "Security"`
        echo $tunnels_name
        exit 1
    fi
    export tunnel_name="$2"
    tunnel_endpoint_ip=`sudo ipsec status | grep -i $tunnel_name | grep -o "===.*" | awk {'print $2'} | cut -d"/" -f1`
    if [ "$tunnel_endpoint_ip" = "" ]; then
        echo "Tunnel does not exists"
        exit 1
    fi
    rtt_average=`ping $tunnel_endpoint_ip -c 20 -i 0.2 -W1 | grep rtt | cut -d= -f2 | cut -d"/" -f2`
    echo "$rtt_average"
    exit 0
fi

if [[ "$1" == "systemd" ]]; then
    running_status=`sudo systemctl status strongswan-starter.service | grep Active | awk '{print $3}' | sed 's/[()]//g'`
    if [[ "$running_status" != "running" ]]; then
        echo "0"
    else
        echo "1"
    fi
    exit 0
fi

if [[ "$1" == "connections" ]]; then
    sudo ipsec statusall | grep -A 1 "ESTABLISHED" | grep "Remote EAP identity" | awk -F': ' '{print $3}'
    exit 0
fi

if [[ "$1" == "ciphers" ]]; then
    sudo ipsec statusall | grep "IKE proposal" | awk -F': ' '{print $3}'
    exit 0
fi

print_help
