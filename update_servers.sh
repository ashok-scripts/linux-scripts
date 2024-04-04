#!/bin/bash

# List of remote servers (replace with your server addresses)
servers=("192.168.1.5")

# Update function
update_server() {
    server=$1
    echo "Updating $server..."

    # Exclude Java update commands
    ssh "$server" 'sudo yum update -y && sudo yum upgrade -y --exclude=java*'
    
    echo "Update completed for $server"
}

# Loop through each server and update
for server in "${servers[@]}"
do
    update_server "$server"
done

echo "All servers updated successfully."
