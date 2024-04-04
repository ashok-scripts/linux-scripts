#!/bin/bash

# Function to remove old kernels
remove_old_kernels() {
    ssh "$1" <<EOF
    # Counting kernels before removal
    echo "Number of kernels before removal:"
    echo "---------------------------------"
    rpm -q kernel
    echo "---------------------------------"

    # Removing old kernels
    package-cleanup --oldkernels --count=1 -y $(rpm -q kernel | grep -v "$(uname -r)" | awk '{print $1}')

    # Counting kernels after removal
    echo "Number of kernels after removal:"
    echo "---------------------------------"
    rpm -q kernel

    read -p "Do you want to reboot the server? (yes/no): " reboot_decision
    if [ "\$reboot_decision" == "yes" ]; then
        echo "Rebooting the server..."
        sudo reboot
    else
        echo "No reboot requested."
    fi

EOF
}

# Prompt user to enter a list of servers
echo "Enter the list of CentOS servers (separated by space):"
read -r servers

# Iterate through each server in the list
for server in $servers; do
    echo "Removing old kernels on $server..."
    remove_old_kernels "$server"
    echo "---------------------------------------------"
done

