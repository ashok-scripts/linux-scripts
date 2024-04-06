#!/bin/bash

# NOTICE TO USERS
# This script is designed to find the most utilized files on a remote host.
# Please ensure that SSH is properly configured on both local and remote machines.
# Use of sudo for SSH may be necessary depending on the permissions of the remote path.

# Prompt user for remote hostname
read -p "Enter remote hostname: " remote_host

# Prompt user for remote path
read -p "Enter remote path: " path

# Prompt user for SSH command (with or without sudo)
read -p "Do you want to use sudo for SSH? (y/n): " use_sudo

# Construct the SSH command
if [[ $use_sudo == "y" ]]; then
    ssh_command="sudo ssh"
else
    ssh_command="ssh"
fi

# Execute the remote command using SSH and capture output
output="$($ssh_command "$remote_host" "/usr/bin/find '$path' -xdev -ls | sort -rnk7 | head -10")"

# Display results
echo "Most utilized files on $remote_host in '$path':"
echo "$output"
