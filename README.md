# Forescout-Test-Network

Solution to automate the validation of a hypothetical feature for a network discovery tool.

# GNS3 Setup Guide

This guide provides step-by-step instructions for setting up GNS3, GNS3 VM, SNMP, and PostgreSQL on an Ubuntu VM. Follow these steps to create a network simulation environment for testing and learning.

## Prerequisites

- VirtualBox (for GNS3 VM)
- GNS3 installation (desktop client)

## Installation Steps

1. **Install GNS3 Desktop Client**:
   - Follow the instructions in the GNS3 documentation to install GNS3.

2. **Install GNS3 VM (VirtualBox)**:
   - Download the GNS3 VM image from the official website.
   - Import the OVA file into VirtualBox.
   - Adjust VM settings (24GB RAM, 8 CPU).

3. **Setting Up GNS3**:
   - Link GNS3 Desktop with the GNS3 VM.
   - Import project files.

4. **Connecting Routers**:
   - Check interfaces configuration and IP addresses, MAC addresses are generated.

5. **Accessing the GNS3 VM**:
   - Start the GNS3 VM.
   - Verify connectivity between GNS3 Desktop and the VM.

6. **Installing SNMP and PostgreSQL**:
   - Install SNMP tools: `sudo apt install snmp snmp-mibs-downloader`.
   - Install PostgreSQL: `sudo apt install postgresql`.
   - Import database file into PostgreSQL.

# Validation

Two validation scripts were created, Python and Bash based

## Python

network-scanner.py uses libraries:
- psycopg2 - PostgreSQL database adapter for Python
- scapy - interactive packet manipulation library

## Bash

network-scanner.sh uses:
- psql - a terminal-based front-end to PostgreSQL
- snmpget - an SNMP application that uses the SNMP GET request to query for information on a network entity

# Usage

Once the test network is running scripts need to be copied to VM or machine hosting the database and run from there, the output should be redirected to a file to create simple report.

# Automation

Scripts can be periodically run using crontab or any other scheduler.
Integration to CI/CD can be realized by using Jenkins or GitLab jobs running periodically or as a part of a pipeline.
In GitLab repository add following lines into `.gitlab-ci.yml`:

```
stages:
  - build
  - test

validate:
  stage: build
  script:
    - bash network-scanner.sh
```

# Automating Validation Procedure

## Strategy Overview

1. **Define Validation Rules and Criteria**:
   - Clearly define rules and criteria for validation.
   - Specify acceptance criteria.

2. **Collect and Organize Datasets**:
   - Gather data on assets requiring validation.
   - Organize them systematically.

3. **Automate Data Verification**:
   - Use scripts or tools to verify data against defined rules.
   - Identify discrepancies or nonconformities.

4. **Determine Error Handling Strategies**:
   - Decide how to handle errors:
     - Correct inconsistencies automatically (if possible).
     - Flag issues for manual review.
     - Trigger alerts or notifications.

5. **Share Findings and Document Results**:
   - Generate reports or notifications.
   - Share validation results with stakeholders.
   - Maintain documentation on the validation process.

6. **Build Ongoing Monitoring Cadence**:
   - Set up scheduled validation runs (e.g., daily, weekly).
   - Automate the entire process for continuous validation
