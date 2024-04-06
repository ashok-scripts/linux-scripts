#!/bin/bash

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
remote_cmd="$($ssh_command "$remote_host" "/usr/bin/find '$path' -xdev -ls | sort -rnk7 | head -10")"

# Display results
output=$(eval "$remote_cmd")
echo "Most utilized files on $remote_host in '$path':"
echo "$output"
