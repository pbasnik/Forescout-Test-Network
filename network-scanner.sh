#!/bin/bash

# Define SNMP community string
SNMP_COMMUNITY="test"

# Extract asset data (IP addresses, MAC addresses, and vendors) from the PostgreSQL database
ASSET_DATA=$(psql -h localhost -U admin -d network -t -c "SELECT ipaddr, mac, vendor FROM devices")

# Perform SNMP discovery for each IP address
while IFS="|" read -r ip mac vendor; do
    # Trim whitespace
    ip=$(echo $ip | xargs)
    mac=$(echo $mac | xargs)
    vendor=$(echo $vendor | xargs)

    # Retrieve sysName using SNMP
    ifPhysAddress=$(snmpget -v2c -c "$SNMP_COMMUNITY" "$ip" RFC1213-MIB:ifPhysAddress.1 | awk -F ': ' '{print $2}')

    mac_formatted=$(echo $ifPhysAddress | tr '[:upper:]' '[:lower:]' | sed 's/ /:/g')
    
    sysObjectID=$(snmpget -v2c -c "$SNMP_COMMUNITY" "$ip" RFC1213-MIB:sysObjectID.0 | awk -F ': ' '{print $2}')

    # Compare MAC address and vendor
    if [[ "$mac" == "$mac_formatted" ]]; then
        echo "Device at IP $ip: MAC address matches ($mac)"
    else
        echo "Device at IP $ip: MAC address mismatch (expected: $mac, actual: $mac_formatted)"
    fi

    if [[ "$sysObjectID" =~ "$vendor" ]]; then
        echo "Device at IP $ip: Vendor matches ($vendor)"
    else
        echo "Device at IP $ip: Vendor mismatch (expected: $vendor, actual: $sysObjectID)"
    fi
done <<< "$ASSET_DATA"
