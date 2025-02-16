#!/bin/bash

# Check if wlan0 is up
if ip link show wlan0 | grep -q "state UP"; then
    # If wlan0 is up, show the Wi-Fi SSID and IP address
    ESSID=$(iw dev wlan0 link | grep "SSID" | cut -d ' ' -f2)
    IP=$(ip addr show wlan0 | grep inet | awk '{print $2}' | cut -d/ -f1)
    echo $ESSID
    
# Check if eth0 is up
elif ip link show eth0 | grep -q "state UP"; then
    # If eth0 is up, show the Ethernet IP address
    IP=$(ip addr show eth0 | grep inet | awk '{print $2}' | cut -d/ -f1)
    echo "Ethernet"
    
else
    # If neither is up, show "No Network"
    echo "No Network"
fi
