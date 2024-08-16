#!/bin/bash

# Define SNMP community string
SNMP_COMMUNITY="test"

# Extract asset data (IP addresses, MAC addresses, and vendors) from the PostgreSQL database
ASSET_DATA=$(psql -h localhost -U admin -d assets -t -c "SELECT ip_address, mac_address, vendor FROM assets")

# Perform SNMP discovery for each IP address
while read -r ip mac vendor; do
    # Retrieve sysName using SNMP
    sysName=$(snmpget -v2c -c "$SNMP_COMMUNITY" "$ip" sysName.0 | awk -F ': ' '{print $2}')

    # Compare MAC address and vendor
    if [[ "$mac" == "$sysName" ]]; then
        echo "Device at IP $ip: MAC address matches ($mac)"
    else
        echo "Device at IP $ip: MAC address mismatch (expected: $mac, actual: $sysName)"
    fi

    if [[ "$vendor" == "$sysName" ]]; then
        echo "Device at IP $ip: Vendor matches ($vendor)"
    else
        echo "Device at IP $ip: Vendor mismatch (expected: $vendor, actual: $sysName)"
    fi
done <<< "$ASSET_DATA"
