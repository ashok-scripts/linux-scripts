#!/bin/bash

# Directory to store collected information
OUTPUT_DIR="/tmp/server_info_$(date +%Y-%m-%d_%H-%M-%S)"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Collect information
{
    echo "Hostname:"
    hostname

    echo "df -h output:"
    df -Th
echo "-------------------------------------------------------------------------------------"
    echo "Network interfaces (using ip command):"
    ip addr show
echo "-------------------------------------------------------------------------------------"
    echo "Routing table summary (using netstat):"
    netstat -nr | head -n 10
echo "-------------------------------------------------------------------------------------"
    echo "Free memory:"
    free -h
echo "-------------------------------------------------------------------------------------"
    echo "System information:"
    uname -a
echo "-------------------------------------------------------------------------------------"
    echo "OS release (redacted):"
    grep -E "(^NAME=|^VERSION=|^ID=|^ID_LIKE=)" /etc/os-release
echo "-------------------------------------------------------------------------------------"
    echo "Currently logged-in users:"
    who
echo "-------------------------------------------------------------------------------------"
    echo "Block devices:"
    lsblk -f
echo "-------------------------------------------------------------------------------------"
    echo "System information summary (using lshw):"
    lshw -short
echo "-------------------------------------------------------------------------------------"
    echo "Installed packages:"
    dpkg -l | grep "^ii"
echo "-------------------------------------------------------------------------------------"
    echo "Running processes (filtered):"
    ps -eo pid,user,comm | head -n 20
} > "$OUTPUT_DIR/server_info.txt"

echo "Information collection completed. Output files are in: $OUTPUT_DIR"
