import psycopg2
from scapy.all import ARP, Ether, srp

def extract_asset_data():
    # Establish a connection to PostgreSQL database
    conn = psycopg2.connect(database="assets", user="admin", password="password", host="localhost", port="5432")

    # Create a cursor
    cur = conn.cursor()

    # Execute a query to retrieve asset data (mac_address and vendor)
    cur.execute("SELECT mac_address, vendor FROM assets")
    asset_data = {row[0]: row[1] for row in cur.fetchall()}

    # Close the cursor and connection
    cur.close()
    conn.close()

    return asset_data

def scan_network(ip_addresses):
    devices_found = {}
    for ip in ip_addresses:
        # Create an ARP request for each IP address
        arp_request = Ether(dst="ff:ff:ff:ff:ff:ff") / ARP(pdst=ip)
        # Send the request and receive responses
        result, _ = srp(arp_request, timeout=1, verbose=False)
        if result:
            # Store the MAC address of the device found
            devices_found[ip] = result[0][1].hwsrc

    return devices_found

def compare_results(asset_data, devices_found):
    for ip, mac_address in devices_found.items():
        if mac_address in asset_data:
            # Compare MAC addresses and vendors
            print(f"Device at IP {ip}: MAC {mac_address}, Vendor {asset_data[mac_address]}")
        else:
            print(f"Device at IP {ip} not found in asset data.")

if __name__ == "__main__":
    # Extract asset data (MAC addresses and vendors) from the database
    extracted_asset_data = extract_asset_data()
    # Extract IP addresses from the asset data
    extracted_ips = list(extracted_asset_data.keys())
    # Scan the network and find devices
    scanned_devices = scan_network(extracted_ips)
    # Compare the results
    compare_results(extracted_asset_data, scanned_devices)