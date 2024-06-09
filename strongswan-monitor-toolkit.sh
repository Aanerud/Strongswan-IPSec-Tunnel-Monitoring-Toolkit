#!/bin/bash
# Author: aanerud
# Date: 09/Juni/2024

# Function to print help message
function print_help {
    echo "You have to declare at least one action"
    echo "Help :"
    echo ""
    echo "./strongswan-monitor-toolkit.sh count_all_tunnels"
    echo "    -> Count all running tunnels."
    echo ""
    echo "./strongswan-monitor-toolkit.sh packetloss [username]"
    echo "    -> Check packetloss to endpoint (other side of tunnel) then show the avg."
    echo ""
    echo "./strongswan-monitor-toolkit.sh rtt [username]"
    echo "    -> Determine RTT to endpoint (other side of tunnel) then show the avg."
    echo ""
    echo "./strongswan-monitor-toolkit.sh systemd"
    echo "    -> Check systemd service of strongswan"
    echo ""
    echo "./strongswan-monitor-toolkit.sh connections"
    echo "    -> Show details of all connections."
    echo ""
    echo "./strongswan-monitor-toolkit.sh ciphers [username]"
    echo "    -> Show SSL ciphers used by the specified user."
    echo ""
    echo "./strongswan-monitor-toolkit.sh connection_time [username]"
    echo "    -> Show connection time of the specified user."
    echo ""
    echo "./strongswan-monitor-toolkit.sh discovery"
    echo "    -> Discover all active connections."
}

# Function to get user, IP, cipher, and connection time mappings
function get_user_ip_cipher_mappings {
    sudo ipsec statusall | awk '
    BEGIN {
        FS=":";
        user = "";
        ip = "";
        cipher = "";
        time = "";
    }
    /ESTABLISHED/ {
        connection = $1;
        sub(/ESTABLISHED /, "", $0);
        match($0, /[0-9]+ (seconds|minutes|hours) ago/);
        time = substr($0, RSTART, RLENGTH);
    }
    /Remote EAP identity/ {
        user = $3;
        gsub(/^[ \t]+|[ \t]+$/, "", user);
    }
    /IKE proposal/ {
        cipher = $3;
        gsub(/^[ \t]+|[ \t]+$/, "", cipher);
    }
    /0\.0\.0\.0\/0 === 10\.10\.10\./ {
        match($0, /=== 10\.10\.10\.[0-9]+/);
        ip = substr($0, RSTART + 4, RLENGTH - 4);
        gsub(/^[ \t]+|[ \t]+$/, "", ip);
        if (user != "" && ip != "" && cipher != "" && time != "") {
            print user, ip, cipher, time;
            user = "";
            ip = "";
            cipher = "";
            time = "";
        }
    }'
}

# Function to get tunnel IP by username
function get_tunnel_ip_by_username {
    local username=$1
    local mappings=$(get_user_ip_cipher_mappings)
    echo "$mappings" | grep "^$username " | awk '{print $2}'
}

# Function to get cipher by username
function get_cipher_by_username {
    local username=$1
    local mappings=$(get_user_ip_cipher_mappings)
    echo "$mappings" | grep "^$username " | awk '{print $3}'
}

# Function to get connection time by username
function get_connection_time_by_username {
    local username=$1
    local mappings=$(get_user_ip_cipher_mappings)
    echo "$mappings" | grep "^$username " | awk '{print $4, $5, $6}'
}

# Handle actions
if [[ "$1" == "count_all_tunnels" ]]; then
    sudo ipsec statusall | grep -c "ESTABLISHED"
    exit 0
fi

if [[ "$1" == "packetloss" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Username is empty."
        exit 1
    fi
    export username="$2"
    tunnel_ip=$(get_tunnel_ip_by_username "$username")
    if [[ "$tunnel_ip" == "" ]]; then
        echo "User does not exist."
        exit 1
    fi
    ping $tunnel_ip -c 50 -i 0.2 -W1 > /tmp/ping_status
    packet_loss_percentage=$(grep loss /tmp/ping_status | awk '{print $6}' | sed 's/%//g')
    echo "$packet_loss_percentage"
    exit 0
fi

if [[ "$1" == "rtt" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Username is empty."
        exit 1
    fi
    export username="$2"
    tunnel_ip=$(get_tunnel_ip_by_username "$username")
    if [[ "$tunnel_ip" == "" ]]; then
        echo "User does not exist."
        exit 1
    fi
    rtt_average=$(ping $tunnel_ip -c 20 -i 0.2 -W1 | grep rtt | cut -d= -f2 | cut -d"/" -f2)
    echo "$rtt_average"
    exit 0
fi

if [[ "$1" == "systemd" ]]; then
    running_status=$(sudo systemctl status strongswan-starter.service | grep Active | awk '{print $3}' | sed 's/[()]//g')
    if [[ "$running_status" != "running" ]]; then
        echo "0"
    else
        echo "1"
    fi
    exit 0
fi

if [[ "$1" == "connections" ]]; then
    sudo ipsec statusall | grep "Remote EAP identity" | awk -F': ' '{print $3}'
    exit 0
fi

if [[ "$1" == "ciphers" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Username is empty."
        exit 1
    fi
    export username="$2"
    cipher=$(get_cipher_by_username "$username")
    if [[ "$cipher" == "" ]]; then
        echo "User does not exist or no cipher found."
        exit 1
    fi
    echo "$cipher"
    exit 0
fi

if [[ "$1" == "connection_time" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Username is empty."
        exit 1
    fi
    export username="$2"
    connection_time=$(get_connection_time_by_username "$username")
    if [[ "$connection_time" == "" ]]; then
        echo "User does not exist or no connection time found."
        exit 1
    fi
    echo "$connection_time"
    exit 0
fi

if [[ "$1" == "discovery" ]]; then
    connections=$(get_user_ip_cipher_mappings)

    json=$(echo "$connections" | awk 'BEGIN { ORS=""; print "{\"data\":[" }
        { printf "%s{\"{#USER}\":\"%s\", \"{#CONNECTION}\":\"%s\"}", (NR==1 ? "" : ","), $1, $2 }
        END { print "]}" }')

    echo $json
    exit 0
fi

if [[ "$1" == "user_connection_status" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Username is empty."
        exit 1
    fi
    export username="$2"
    tunnel_ip=$(get_tunnel_ip_by_username "$username")
    if [[ "$tunnel_ip" == "" ]]; then
        echo "disconnected"
        exit 0
    else
        echo "connected"
        exit 0
    fi
fi

print_help
